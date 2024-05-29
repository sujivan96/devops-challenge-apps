variable "name" {
  type        = string
  description = "The name of the Virtual Machine. Changing this forces a new resource to be created."

  validation {
    condition     = length(var.name) <= 15
    error_message = "The name must be less than or equal to 15 characters in length."
  }
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

variable "name_suffix" {
  type        = string
  description = "The suffix used to calculate names of the supporting Azure Resources. Changing this forces a new resources to be created."
}

variable "location" {
  type        = string
  description = "The Azure location where the Virtual Machine will be deployed. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Virtual Machine will be deployed. Changing this forces a new resource to be created."
}

# Networking
variable "subnet_id" {
  type        = string
  description = "The id of the subnet that the Virtual Machine's Network Interface Card will be attached to."
}

variable "enable_public_ip" {
  description = "Enable or disable public ip."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "SKU to be used with this public IP - Basic or Standard."
  type        = string
  default     = "Standard"

  validation {
    condition     = (contains(["Basic", "Standard"], var.public_ip_sku))
    error_message = "Public IP sku must be one of Basic or Standard."
  }
}

variable "size" {
  type        = string
  description = "The SKU which should be used for this Virtual Machine."
  default     = "Standard_A4_v2"
}

# Admin User
variable "admin_username" {
  type        = string
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created. Will be random if none is passed"
  default     = ""
}

variable "admin_password" {
  type        = string
  description = "The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. Will be random if none is passed"
  default     = ""
  sensitive   = true
}

variable "os_disk_caching" {
  type        = string
  description = "The Type of Caching which should be used for the Internal OS Disk."
  default     = "ReadWrite"

  validation {
    condition = (
      contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    )
    error_message = "The value for os_disk_caching must be one of None, ReadOnly or ReadWrite."
  }
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "The Type of Storage Account which should back this the Internal OS Disk. Changing this forces a new resource to be created."
  default     = "Standard_LRS"

  validation {
    condition = (
      contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_storage_account_type)
    )
    error_message = "The value for os_disk_storage_account_type must be one of Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS or Premium_ZRS."
  }
}

variable "source_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. If source_image_id is supplied the following are ignored. source_image_publisher, source_image_offer, source_image_sku, source_image_version. Changing this forces a new resource to be created"
  type        = string
  default     = null
}

variable "source_image_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machines. One of either source_image_id or source_image_reference must be set. Changing this forces a new resource to be created."
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "source_image_offer" {
  description = "Specifies the offer of the image used to create the virtual machines. One of either source_image_id or source_image_offer must be set. Changing this forces a new resource to be created."
  type        = string
  default     = "WindowsServer"
}

variable "source_image_sku" {
  description = "Specifies the SKU of the image used to create the virtual machines. One of either source_image_id or source_image_sku must be set. Changing this forces a new resource to be created."
  type        = string
  default     = "2019-Datacenter"
}

variable "source_image_version" {
  description = "Specifies the version of the image used to create the virtual machines. One of either source_image_id or source_image_version must be set. Changing this may cause a new resource to be created"
  type        = string
  default     = "latest"
}

variable "enable_boot_diagnostics" {
  description = "Enable or Disable boot diagnostics."
  type        = bool
  default     = false
}

variable "boot_diagnostics_storage_account_uri" {
  type        = string
  description = "Uri for boot_diagnostics storage account."
  default     = ""
}

variable "boot_diagnostics_sa_type" {
  description = "Storage account type for boot diagnostics. Not used if boot_diagnostics_storage_account_uri is supplied."
  type        = string
  default     = "Standard_LRS"
}

variable "action_group_id" {
  type        = string
  description = "The ID of the action group to be used for alerting."
  default     = null
}


variable "managed_disks" {
  type        = list(map(string))
  description = "A list of managed disks (defined as maps) for the Virtual Machine that includes the following attributes: storage_account_type, create_option, size_gb, disk_attachment_lun, and disk_attachment_caching."
  default     = []
  # Example list of map of strings that can be passed to the managed_disks variable
  # managed_disks = [
  #     {
  #       storage_account_type      = "Standard_LRS"
  #       create_option             = "Empty"
  #       size_gb                   = "10"
  #       disk_attachment_lun       = "10"
  #       disk_attachment_caching   = "ReadWrite"
  #     },
  #     {
  #       storage_account_type      = "Standard_LRS"
  #       create_option             = "Empty"
  #       size_gb                   = "12"
  #       disk_attachment_lun       = "20"
  #       disk_attachment_caching   = "ReadWrite"
  #     }
  #   ]
}

# Domain Join settings
variable "enable_domain_join" {
  description = "A value of 'true' indicates that the Virtual Machine should be joined to the windows domain."
  type        = bool
  default     = false
}

variable "domain_join_active_directory_domain" {
  description = "The name of the Active Directory domain to join."
  type        = string
  default     = null
}

variable "domain_join_ou_path" {
  description = "An organizational unit (OU) within an Active Directory to place computers."
  type        = string
  default     = null
}

variable "domain_join_active_directory_username" {
  description = "The username of an account with permissions to bind machines to the Active Directory Domain."
  type        = string
  default     = null
}

variable "domain_join_active_directory_password" {
  description = "The password of the account with permissions to bind machines to the Active Directory Domain."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "A list of IP Addresses defining the DNS Servers which should be used for this Network Interface."
  type        = list(string)
  default     = []
}

# Metadata
variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the resource."
}