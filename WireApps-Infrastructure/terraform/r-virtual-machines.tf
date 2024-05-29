module "virtual_machine_wireapps" {
  source = "../modules/virtual-machine/windows"

  name                = "vm${var.env_acronym}dnaruntime"
  description         = "A Virtual Machine used for running a ......."
  name_suffix         = "${var.department}-${var.app_acronym}-${var.env_acronym}-${var.region_acronym}"
  resource_group_name = module.resource_group_wireapps.name
  location            = module.resource_group_wireapps.location
  dns_servers         = ""

  admin_username = "sysadmin"
  subnet_id      = module.subnet_api_management.id

  enable_public_ip = false

  # Providing Action Group for alerting notification
  action_group_id = module.alerting_rides_data_analytics.action_group_id


  size                         = var.integration_runtime_size
  os_disk_storage_account_type = var.integration_runtime_os_disk_storage_account_type

  source_image_id = azurerm_image.golden_image.id

  managed_disks = [
    {
      storage_account_type    = "Standard_LRS"
      create_option           = "Empty"
      size_gb                 = "10"
      disk_attachment_lun     = "10"
      disk_attachment_caching = "ReadWrite"
    }
  ]

  tags = var.tags
}

module "virtual_machine_powerbi_data_gateway" {
  source = "../modules/virtual-machine/windows"

  name                = "vmgateway${var.env_acronym}"
  description         = "A Virtual Machine used as a data gateway for Power BI."
  name_suffix         = "${var.department}-${var.app_acronym}-data-gateway-${var.env_acronym}-${var.region_acronym}"
  resource_group_name = module.resource_group_data_and_analytics.name
  location            = module.resource_group_data_and_analytics.location

  admin_username = "sysadmin"
  subnet_id      = module.subnet_integration_runtime.id

  enable_public_ip = false

  # Providing Action Group for alerting notification
  action_group_id = module.alerting_rides_data_analytics.action_group_id


  size                         = var.powerbi_data_gateway_size
  os_disk_storage_account_type = var.powerbi_data_gateway_os_disk_storage_account_type

  source_image_id = azurerm_image.golden_image.id

  managed_disks = [
    {
      storage_account_type    = "Standard_LRS"
      create_option           = "Empty"
      size_gb                 = "10"
      disk_attachment_lun     = "10"
      disk_attachment_caching = "ReadWrite"
    }
  ]

  tags = var.tags
}

