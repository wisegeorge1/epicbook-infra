data "azurerm_platform_image" "ubuntu" {
  location  = var.location
  publisher = "Canonical"
  offer     = var.ubuntu_offer
  sku       = var.ubuntu_sku
  version   = var.ubuntu_version
}

# =========================================================
# Frontend Public IP
# =========================================================

resource "azurerm_public_ip" "frontend" {
  name                = "${var.project_name}-frontend-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

# =========================================================
# Backend NAT Public IP
# =========================================================

resource "azurerm_public_ip" "backend_nat" {
  name                = "${var.project_name}-backend-nat-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

# =========================================================
# Backend NAT Gateway
# =========================================================

resource "azurerm_nat_gateway" "backend" {
  name                = "${var.project_name}-backend-nat"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "backend" {
  nat_gateway_id       = azurerm_nat_gateway.backend.id
  public_ip_address_id = azurerm_public_ip.backend_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "backend" {
  subnet_id      = azurerm_subnet.backend.id
  nat_gateway_id = azurerm_nat_gateway.backend.id
}

# =========================================================
# Frontend NIC
# =========================================================

resource "azurerm_network_interface" "frontend" {
  name                = "${var.project_name}-frontend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "frontend-ipconfig"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.frontend.id
  }

  tags = var.tags
}

# =========================================================
# Backend NIC
# =========================================================

resource "azurerm_network_interface" "backend" {
  name                = "${var.project_name}-backend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "backend-ipconfig"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# =========================================================
# Frontend VM
# =========================================================

resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "${var.project_name}-frontend-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  size = var.frontend_vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.frontend.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${var.project_name}-frontend-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_type
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.ubuntu.publisher
    offer     = data.azurerm_platform_image.ubuntu.offer
    sku       = data.azurerm_platform_image.ubuntu.sku
    version   = data.azurerm_platform_image.ubuntu.version
  }

  tags = merge(
    var.tags,
    {
      Role = "frontend-devops-agent"
    }
  )
}

# =========================================================
# Backend VM
# =========================================================

resource "azurerm_linux_virtual_machine" "backend" {
  name                = "${var.project_name}-backend-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  size = var.backend_vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.backend.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${var.project_name}-backend-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_type
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.ubuntu.publisher
    offer     = data.azurerm_platform_image.ubuntu.offer
    sku       = data.azurerm_platform_image.ubuntu.sku
    version   = data.azurerm_platform_image.ubuntu.version
  }

  tags = merge(
    var.tags,
    {
      Role = "backend"
    }
  )
}
