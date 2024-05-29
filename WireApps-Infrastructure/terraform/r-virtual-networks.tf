module "virtual_network_wireapps" {
  source = "../modules/virtual-network"

  name                = "vnet-${var.department}-${var.app_acronym}-${var.env_acronym}-${var.region_acronym}"
  description         = "The main virtual network for this environment."
  resource_group_name = module.resource_group_wireapps.name
  location            = module.resource_group_wireapps.location
  address_space       = var.vnet_address_space

  virtual_network_peerings = [
    {
      name                = var.rides_hub_virtual_network_name
      resource_group_name = var.rides_hub_virtual_network_resource_group_name
    }
  ]

  log_analytics_workspace_id = "module.log_analytics_workspace.id"

  tags = var.tags
}