variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "name" {
  type        = string
  description = "The name of the virtual network. Changing this forces a new resource to be created."
}

variable "description" {
  type        = string
  description = "A description for the resources (less than or equal to 512 characters)."
  default     = "A resource deployed by Terraform."

  validation {
    condition = (
      length(var.description) < 512
    )
    error_message = "The description must be less than or equal to 512 characters."
  }
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers."
  type        = list(string)
  default     = []
}

variable "bgp_community" {
  type        = string
  description = "The BGP community attribute in format <as-number>:<community-value>."
  default     = null
}

variable "edge_zone" {
  type        = string
  description = "Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
  default     = null
}

variable "flow_timeout_in_minutes" {
  type        = number
  description = "The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  default     = 4

  validation {
    condition = (
      var.flow_timeout_in_minutes >= 4 &&
      var.flow_timeout_in_minutes <= 30
    )
    error_message = "The flow timeout in minutes must be between 4 and 30."
  }
}

variable "ddos_protection_plan_id" {
  type        = string
  description = "The ID of the DDoS Protection Plan to enable."
  default     = null
}

# variable "remote_virtual_network_ids" {
#   type        = list(string)
#   description = "A list of IDs of remove virtual networks for the spoke network to be peered to.  This is only a one-way peering.  Peering from the remote virtual network will require manual intervention."
#   default     = []
# }

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
  default     = ["VMProtectionAlerts"]
}

variable "metric_categories" {
  type        = list(string)
  description = "The name of a Diagnostic Metric Category for this Resource."
  default     = ["AllMetrics"]
}

variable "virtual_network_peerings" {
  type        = list(map(string))
  description = "A list of maps containing the names and resource groups of remote virtual networks for peering."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the resource."
}