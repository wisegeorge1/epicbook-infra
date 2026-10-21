output "resource_group_name" {
  description = "EpicBook resource group."
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "EpicBook Azure region."
  value       = azurerm_resource_group.main.location
}

output "vnet_name" {
  description = "EpicBook virtual network."
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "EpicBook virtual network ID."
  value       = azurerm_virtual_network.main.id
}

output "frontend_public_ip" {
  description = "Frontend public IP."
  value       = azurerm_public_ip.frontend.ip_address
}

output "frontend_private_ip" {
  description = "Frontend private IP."
  value       = azurerm_network_interface.frontend.private_ip_address
}

output "backend_private_ip" {
  description = "Backend private IP."
  value       = azurerm_network_interface.backend.private_ip_address
}

output "backend_nat_public_ip" {
  description = "Backend outbound NAT IP."
  value       = azurerm_public_ip.backend_nat.ip_address
}

output "mysql_fqdn" {
  description = "Private MySQL server FQDN."
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_database_name" {
  description = "EpicBook MySQL database."
  value       = azurerm_mysql_flexible_database.bookstore.name
}
