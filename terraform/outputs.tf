output "resource_group_name" {
  description = "Name of the EpicBook resource group."
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Azure region of the EpicBook resource group."
  value       = azurerm_resource_group.main.location
}

output "vnet_name" {
  description = "Name of the EpicBook virtual network."
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "Resource ID of the EpicBook virtual network."
  value       = azurerm_virtual_network.main.id
}
