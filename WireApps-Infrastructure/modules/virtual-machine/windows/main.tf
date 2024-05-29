# Terraform docs: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "username" {
  length  = 20
  special = false
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "password" {
  count = (var.admin_password == "" ? 1 : 0)

  length           = 32
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "!@#$%*()-_=+[]{}:?"
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id
resource "random_id" "boot_diagnostics_storage_account" {
  keepers = {
    virtual_machine_name = var.name
  }

  byte_length = 6
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "main" {
  count = var.enable_boot_diagnostics ? 1 : 0

  name                = "bootdiag${lower(random_id.boot_diagnostics_storage_account.hex)}"
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = element(split("_", var.boot_diagnostics_sa_type), 0)
  account_replication_type = element(split("_", var.boot_diagnostics_sa_type), 1)

  tags = var.tags
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "main" {
  count = (var.enable_public_ip == true ? 1 : 0)

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = var.public_ip_sku

  tags = var.tags
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# Microsoft docs: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-network-interface
resource "azurerm_network_interface" "main" {
  name                = "nic-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.main[0].id : null
  }

  tags = var.tags
}
resource "azurerm_linux_virtual_machine" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  admin_username      = local.admin_username
  admin_password      = local.admin_password

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk
resource "azurerm_managed_disk" "main" {
  count = length(var.managed_disks)

  name                = "dsk${count.index + 1}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = var.managed_disks[count.index].storage_account_type
  create_option        = var.managed_disks[count.index].create_option
  disk_size_gb         = tonumber(var.managed_disks[count.index].size_gb)

  tags = var.tags
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment
resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  count = length(var.managed_disks)

  managed_disk_id    = azurerm_managed_disk.main[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  lun                = var.managed_disks[count.index].disk_attachment_lun
  caching            = var.managed_disks[count.index].disk_attachment_caching

  # this resource does not support tags
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension
resource "azurerm_virtual_machine_extension" "main" {
  count = (var.enable_domain_join == true ? 1 : 0)

  name                       = "${var.name}-join-domain"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "Name": "${var.domain_join_active_directory_domain}",
        "OUPath": "${var.domain_join_ou_path != null ? var.domain_join_ou_path : ""}",
        "User": "${var.domain_join_active_directory_username}@${var.domain_join_active_directory_domain}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.domain_join_active_directory_password}"
    }
SETTINGS

  tags = var.tags
}

# Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert
resource "azurerm_monitor_activity_log_alert" "vm_heartbeat" {
  count = var.action_group_id != null ? 1 : 0

  name                = "${var.name}-heartbeat"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_windows_virtual_machine.main.id]
  description         = "The VM ${var.name} is unreachable. This can be due to the VM being stopped, restarted, the agent being unresponsive or the guest OS being unresponsive."

  criteria {
    resource_id = azurerm_windows_virtual_machine.main.id
    category    = "ResourceHealth"

    resource_health {
      current  = ["Degraded", "Unavailable", "Unknown"]
      previous = ["Available"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }
}