# Subnet attributes
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "The location/region where the subnets associated resources are created. Changing this forces a new resource to be created."
}

variable "name" {
  type        = string
  description = "The name of the subnet. Changing this forces a new resource to be created."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address prefixes to use for the subnet."
}

variable "service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet.  Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web."
  default     = []
}

variable "private_endpoint_network_policies_enabled" {
  type        = bool
  description = "Enable or disable network policies for the private endpoint on the subnet. Setting this to true will enable the policy and setting this to false will disable the policy. Defaults to true."
  default     = true
}

variable "delegation" {
  type        = map(list(any))
  description = <<EOF
Configuration delegations on subnet
object({
  name = object({
    name = string,
    actions = list(string)
  })
})
Possible values for name include Microsoft.ApiManagement/service, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/managedResolvers, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments and PaloAltoNetworks.Cloudngfw/firewalls.
Possible values for actions include Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
EOF
  default     = {}
}

# Network security group attributes
variable "network_security_group_inbound_rules" {
  type        = list(map(string))
  description = "List of objects that represent the configuration of each inbound rule."
  default     = []
  # inbound_rules = [
  #   {
  #     name                       = ""
  #     priority                   = ""
  #     access                     = ""
  #     protocol                   = ""
  #     source_address_prefix      = ""
  #     source_port_range          = ""
  #     destination_address_prefix = ""
  #     destination_port_range     = ""
  #     description                = ""
  #   }
  # ]
}

variable "network_security_group_outbound_rules" {
  type        = list(map(string))
  description = "List of objects that represent the configuration of each outbound rule."
  default     = []
  # outbound_rules = [
  #   {
  #     name                       = ""
  #     priority                   = ""
  #     access                     = ""
  #     protocol                   = ""
  #     source_address_prefix      = ""
  #     source_port_range          = ""
  #     destination_address_prefix = ""
  #     destination_port_range     = ""
  #     description                = ""
  #   }
  # ]
}

# Diganostic Settings Variables
variable "enable_diagnostic_settings" {
  type        = bool
  description = "Should Diagnostic settings be enabled for this resource?"
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "log_categories" {
  type        = list(string)
  description = "The name of a Diagnostic Log Category for this Resource."
  default     = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the resource."
}
