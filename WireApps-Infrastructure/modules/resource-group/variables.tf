variable "name" {
  type        = string
  description = "The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
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

variable "location" {
  type        = string
  description = "The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  default     = "eastus"
}

variable "contributors" {
  type        = list(string)
  description = "A list of users or principals that need contributor access to the resource group."
  default     = []
}

variable "monitoring_contributor_objects_ids" {
  type        = set(string)
  description = "Can read all monitoring data and edit monitoring settings. See also Get started with roles, permissions, and security with Azure Monitor."
  default     = []
}

variable "monitoring_reader_objects_ids" {
  type        = set(string)
  description = "Can read all monitoring data (metrics, logs, etc.). See also Get started with roles, permissions, and security with Azure Monitor."
  default     = []
}

variable "RIDES_appInsight_reader_objects_ids" {
  type        = set(string)
  description = "Custom role to read UAT and Production AppInsight"
  default     = []
}


variable "workbook_contributor_objects_ids" {
  type        = set(string)
  description = "Can read all monitoring data and edit monitoring settings. See also Get started with roles, permissions, and security with Azure Monitor."
  default     = []
}

variable "log_analytics_reader_objects_ids" {
  type        = set(string)
  description = "Log Analytics Reader can view and search all monitoring data as well as and view monitoring settings, including viewing the configuration of Azure diagnostics on all Azure resources."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the resource."
}
