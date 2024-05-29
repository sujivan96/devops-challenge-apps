output "id" {
  value       = azurerm_windows_virtual_machine.main.id
  description = "The id of Virtual Machine"
}

output "name" {
  value       = azurerm_windows_virtual_machine.main.name
  description = "The name of the Virtual Machine."
}

output "private_ip" {
  value       = azurerm_network_interface.main.private_ip_address
  description = "The private IP Address of the Virtual Machine"
}

output "network_interface_id" {
  value       = azurerm_network_interface.main.id
  description = "The id of the Virtual Machine's network interface card"
}

# Credentials
output "admin_username" {
  value       = local.admin_username
  description = "The username of the local administrator used for the Virtual Machine."
}

output "admin_password" {
  value       = local.admin_password
  description = "The Password which should be used for the local-administrator on this Virtual Machine."
  sensitive   = true
}