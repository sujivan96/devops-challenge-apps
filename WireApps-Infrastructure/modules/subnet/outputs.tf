output "id" {
  value       = azurerm_subnet.this.id
  description = "The subnet ID."
  sensitive   = false
}

output "name" {
  value       = azurerm_subnet.this.name
  description = "The name of the subnet."
  sensitive   = false
}

output "resource_group_name" {
  value       = azurerm_subnet.this.resource_group_name
  description = "The name of the resource group in which the subnet is created in."
  sensitive   = false
}

output "virtual_network_name" {
  value       = azurerm_subnet.this.virtual_network_name
  description = "The name of the virtual network in which the subnet is created in."
  sensitive   = false
}

output "address_prefixes" {
  value       = azurerm_subnet.this.address_prefixes
  description = "The address prefixes for the subnet"
  sensitive   = false
}