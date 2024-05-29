output "name" {
  value       = azurerm_resource_group.main.name
  description = "The name of the resource group."
  sensitive   = false
}

output "location" {
  value       = azurerm_resource_group.main.location
  description = "The location of the resource group."
  sensitive   = false
}

output "id" {
  value       = azurerm_resource_group.main.id
  description = "The ID of the Resource Group."
  sensitive   = false
}