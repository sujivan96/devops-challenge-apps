output "id" {
  value       = azurerm_virtual_network.this.id
  description = "The virtual NetworkConfiguration ID."
  sensitive   = false
}

output "name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the virtual network."
  sensitive   = false
}

output "address_space" {
  value       = azurerm_virtual_network.this.address_space
  description = "The list of address spaces used by the virtual network."
  sensitive   = false
}

output "guid" {
  value       = azurerm_virtual_network.this.guid
  description = "The GUID of the virtual network."
  sensitive   = false
}