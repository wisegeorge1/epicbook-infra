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
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the application resource group."
  type        = string
  default     = "rg-epicbook"
}

variable "vnet_address_space" {
  description = "Address space for the EpicBook virtual network."
  type        = list(string)

  default = [
    "10.40.0.0/16"
  ]
}

variable "frontend_subnet_cidr" {
  description = "CIDR range for the frontend subnet."
  type        = string
  default     = "10.40.1.0/24"
}

variable "backend_subnet_cidr" {
  description = "CIDR range for the backend subnet."
  type        = string
  default     = "10.40.2.0/24"
}

variable "database_subnet_cidr" {
  description = "CIDR range for the MySQL delegated subnet."
  type        = string
  default     = "10.40.3.0/24"
}

variable "management_subnet_cidr" {
  description = "CIDR range for the management/self-hosted-agent subnet."
  type        = string
  default     = "10.40.10.0/24"
}

variable "admin_username" {
  description = "Linux administrator username for the Azure VMs."
  type        = string
  default     = "azureuser"
}

variable "admin_source_cidr" {
  description = "Public IP/CIDR allowed to SSH to the management and frontend systems."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_source_cidr, 0))
    error_message = "admin_source_cidr must be a valid CIDR, for example 203.0.113.10/32."
  }
}

variable "ssh_public_key" {
  description = "SSH public key installed on the Azure VMs."
  type        = string
  sensitive   = true
}

variable "frontend_vm_size" {
  description = "Azure VM size for the frontend VM."
  type        = string
  default     = "Standard_B2s"
}

variable "backend_vm_size" {
  description = "Azure VM size for the backend VM."
  type        = string
  default     = "Standard_B2s"
}

variable "agent_vm_size" {
  description = "Azure VM size for the Azure DevOps self-hosted agent."
  type        = string
  default     = "Standard_B2s"
}

variable "mysql_admin_username" {
  description = "Administrator username for Azure Database for MySQL."
  type        = string
  default     = "epicbookadmin"
}

variable "mysql_admin_password" {
  description = "Administrator password for Azure Database for MySQL."
  type        = string
  sensitive   = true
}

variable "mysql_sku_name" {
  description = "SKU for the MySQL Flexible Server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL major version."
  type        = string
  default     = "8.0.21"
}

variable "tags" {
  description = "Common Azure resource tags."
  type        = map(string)

  default = {
    Project     = "EpicBook"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
