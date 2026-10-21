variable "project_name" {
  description = "Short project name used when generating Azure resource names."
  type        = string
  default     = "epicbook"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Application resource group."
  type        = string
  default     = "rg-epicbook"
}

variable "vnet_address_space" {
  description = "Virtual network address space."
  type        = list(string)

  default = [
    "10.40.0.0/16"
  ]
}

variable "frontend_subnet_cidr" {
  description = "Frontend subnet."
  type        = string
  default     = "10.40.1.0/24"
}

variable "backend_subnet_cidr" {
  description = "Backend subnet."
  type        = string
  default     = "10.40.2.0/24"
}

variable "database_subnet_cidr" {
  description = "Database subnet."
  type        = string
  default     = "10.40.3.0/24"
}

variable "admin_username" {
  description = "Linux administrator username."
  type        = string
  default     = "azureuser"
}

variable "admin_source_cidr" {
  description = "CIDR allowed to SSH to the frontend VM."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_source_cidr, 0))
    error_message = "Provide a valid CIDR such as 203.0.113.10/32."
  }
}

variable "ssh_public_key" {
  description = "SSH public key installed on both VMs."
  type        = string
  sensitive   = true
}

variable "frontend_vm_size" {
  description = "Frontend VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "backend_vm_size" {
  description = "Backend VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "os_disk_storage_type" {
  description = "VM OS disk storage type."
  type        = string
  default     = "Standard_LRS"
}

variable "ubuntu_offer" {
  description = "Ubuntu Marketplace offer."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "ubuntu_sku" {
  description = "Ubuntu Marketplace SKU."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "ubuntu_version" {
  description = "Ubuntu Marketplace image version."
  type        = string
  default     = "latest"
}

variable "mysql_admin_username" {
  description = "MySQL administrator username."
  type        = string
  default     = "epicbookadmin"
}

variable "mysql_admin_password" {
  description = "MySQL administrator password."
  type        = string
  sensitive   = true
}

variable "mysql_sku_name" {
  description = "MySQL Flexible Server SKU."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL version."
  type        = string
  default     = "8.0.21"
}

variable "http_port" {
  description = "Frontend HTTP port."
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port."
  type        = number
  default     = 443
}

variable "backend_app_port" {
  description = "EpicBook backend application port."
  type        = number
  default     = 8080
}

variable "mysql_port" {
  description = "MySQL port."
  type        = number
  default     = 3306
}

variable "ssh_port" {
  description = "SSH port."
  type        = number
  default     = 22
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)

  default = {
    Project     = "EpicBook"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
