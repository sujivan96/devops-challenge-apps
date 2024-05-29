# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "this" {
  # Required attributes
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes

  # Optional attributes
  service_endpoints                         = var.service_endpoints
  private_endpoint_network_policies_enabled = var.private_endpoint_network_policies_enabled

  # Blocks
  dynamic "delegation" {
    for_each = var.delegation
    content {
      name = delegation.key # A name for this delegation.
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name                                                                       # The name of service to delegate to. 
          actions = lookup(service_delegation.value, "actions", null) != null ? service_delegation.value.actions : null # A list of Actions which should be delegated. This list is specific to the service to delegate to.
        }
      }
    }
  }
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "this" {
  # Required attributes
  name                = "nsg-for-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "inbound" {
  for_each = { for rule in var.network_security_group_inbound_rules : rule.name => rule }

  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name

  direction                  = "Inbound"
  name                       = each.value.name
  priority                   = each.value.priority
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_address_prefix      = lookup(each.value, "source_address_prefix", "*")
  source_port_range          = lookup(each.value, "source_port_range", "*")
  destination_address_prefix = lookup(each.value, "destination_address_prefix", "*")
  destination_port_range     = lookup(each.value, "destination_port_range", "*")
  description                = lookup(each.value, "description", null)
}

resource "azurerm_network_security_rule" "outbound" {
  for_each = { for rule in var.network_security_group_outbound_rules : rule.name => rule }

  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  direction                   = "Outbound"
  name                        = each.value.name
  priority                    = each.value.priority
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = lookup(each.value, "source_address_prefix", "*")
  source_port_range           = lookup(each.value, "source_port_range", "*")
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", "*")
  destination_port_range      = lookup(each.value, "destination_port_range", "*")
  description                 = lookup(each.value, "description", null)
}

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# Logging and Monitoring
# Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
resource "azurerm_monitor_diagnostic_setting" "main" {
  count = var.enable_diagnostic_settings == true ? 1 : 0

  name               = "${var.name}-diag"
  target_resource_id = azurerm_network_security_group.this.id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_categories

    content {
      category = enabled_log.value
    }
  }
}