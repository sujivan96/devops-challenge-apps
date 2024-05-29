# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "this" {
  # Required attributes
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space

  # Optional attributes
  dns_servers             = var.dns_servers
  bgp_community           = var.bgp_community
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  # Blocks
  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id == null ? [] : [var.ddos_protection_plan_id]
    content {
      id     = ddos_protection_plan.value
      enable = true
    }
  }

  tags = merge(
    var.tags,
    {
      Description = var.description
    }
  )
}

# Logging and Monitoring
# Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
resource "azurerm_monitor_diagnostic_setting" "main" {
  count = var.enable_diagnostic_settings == true ? 1 : 0

  name               = "${var.name}-diag"
  target_resource_id = azurerm_virtual_network.this.id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.metric_categories

    content {
      category = metric.value
      enabled  = true
    }
  }
}

# The current Terraform service principal does not have permission 
# to perform action 'peer/action' on linked scope(s).  Leaving code for future.

# Terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count = length(var.virtual_network_peerings)

  name                 = lower("${azurerm_virtual_network.this.name}-to-${var.virtual_network_peerings[count.index]["name"]}")
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  # This is only valid because Terraform only has permissions to peer in this
  # case with resources within its own subscription.  Another method would
  # need to be explored if Terraform could peer with networkous outside of
  # the scope of its subscriptions.
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.virtual_network_peerings[count.index]["resource_group_name"]}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_peerings[count.index]["name"]}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  # allow_gateway_transit must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count = length(var.virtual_network_peerings)

  name                         = lower("${var.virtual_network_peerings[count.index]["name"]}-to-${azurerm_virtual_network.this.name}")
  resource_group_name          = var.virtual_network_peerings[count.index]["resource_group_name"]
  virtual_network_name         = var.virtual_network_peerings[count.index]["name"]
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  # allow_gateway_transit must be set to false for vnet Global Peering
  allow_gateway_transit = false
}