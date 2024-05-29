
module "subnet_api_management" {
  source = "../modules/subnet"

  name                 = "sub-${var.department}-${var.app_acronym}-${var.env_acronym}-${var.region_acronym}"
  resource_group_name  = module.resource_group_wireapps.name
  location             = module.resource_group_wireapps.location
  virtual_network_name = module.virtual_network_wireapps.name
  address_prefixes     = var.api_management_subnet_address_prefixes
  service_endpoints = [
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.AzureCosmosDB"
  ]
  # An NSG rule that opens port 3443 is required when using an internal or external network type.
  # This block ensures that rule is automatically created when required.
  network_security_group_inbound_rules = [
    {
      name                       = "AllowApimManagement"
      priority                   = 100
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3443"
      source_address_prefix      = "ApiManagement"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowLoadBalancer"
      priority                   = 200
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6390"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "VirtualNetwork"
    }
  ]

  network_security_group_outbound_rules = [
    {
      name                       = "AllowAzureStorage"
      priority                   = 100
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "Storage"
    },
    {
      name                       = "AllowAzureSQL"
      priority                   = 200
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "SQL"
    },
    {
      name                       = "AllowAzureKeyVault"
      priority                   = 300
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureKeyVault"
    },
  ]

  tags = var.tags
}
