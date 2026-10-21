# =========================================================
# Frontend NSG
# =========================================================

resource "azurerm_network_security_group" "frontend" {
  name                = "${var.project_name}-frontend-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "frontend_http" {
  name                        = "allow-http-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range      = "*"
  destination_port_range = tostring(var.http_port)

  source_address_prefix      = "Internet"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.frontend.name
}

resource "azurerm_network_security_rule" "frontend_ssh" {
  name                        = "allow-ssh-from-admin"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range      = "*"
  destination_port_range = tostring(var.ssh_port)

  source_address_prefix      = var.admin_source_cidr
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.frontend.name
}

resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id = azurerm_subnet.frontend.id

  network_security_group_id = azurerm_network_security_group.frontend.id
}

# =========================================================
# Backend NSG
# =========================================================

resource "azurerm_network_security_group" "backend" {
  name                = "${var.project_name}-backend-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "backend_ssh" {
  name                        = "allow-ssh-from-frontend"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range      = "*"
  destination_port_range = tostring(var.ssh_port)

  source_address_prefix      = var.frontend_subnet_cidr
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.backend.name
}

resource "azurerm_network_security_rule" "backend_app" {
  name                        = "allow-app-from-frontend"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range      = "*"
  destination_port_range = tostring(var.backend_app_port)

  source_address_prefix      = var.frontend_subnet_cidr
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.backend.name
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id = azurerm_subnet.backend.id

  network_security_group_id = azurerm_network_security_group.backend.id
}
