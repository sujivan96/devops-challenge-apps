variable "name" {
  type        = string
  description = "postgresql server name"
 
}

variable "location" {
  type        = string
  description = "location"
  default     = "eus"
 
}
variable "resource_group_name" {
  type        = string
  description = "resource group name"
 
}
variable "administrator_login" {
  type        = string
  description = "administrator login username"
 
}
variable "postgresql_database" {
  type        = string
  description = "postgresql Db name"
 
}
