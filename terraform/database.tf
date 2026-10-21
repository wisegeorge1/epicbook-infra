resource "azurerm_private_dns_zone" "mysql" {
  name                = "epicbook.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "${var.project_name}-mysql-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_mysql_flexible_server" "main" {
  name                = "${var.project_name}-mysql"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  version  = var.mysql_version
  sku_name = var.mysql_sku_name

  delegated_subnet_id = azurerm_subnet.database.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  public_network_access = "Disabled"

  storage {
    size_gb           = 20
    auto_grow_enabled = true
  }

  backup_retention_days = 7

  tags = var.tags
}

resource "azurerm_mysql_flexible_database" "bookstore" {
  name                = "bookstore"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name

  charset   = "utf8mb4"
  collation = "utf8mb4_unicode_ci"
}
