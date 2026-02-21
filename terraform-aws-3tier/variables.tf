variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name for resource naming"
  type        = string
  default     = "myapp"

  validation {
    condition     = length(var.app_name) <= 20 && can(regex("^[a-z0-9-]+$", var.app_name))
    error_message = "App name must be lowercase alphanumeric and hyphens, max 20 characters."
  }
}

# ============================================================================
# VPC AND NETWORKING
# ============================================================================

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1 CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2 CIDR block"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "Private subnet 1 CIDR block"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private subnet 2 CIDR block"
  type        = string
  default     = "10.0.11.0/24"
}

variable "db_subnet_1_cidr" {
  description = "Database subnet 1 CIDR block"
  type        = string
  default     = "10.0.20.0/24"
}

variable "db_subnet_2_cidr" {
  description = "Database subnet 2 CIDR block"
  type        = string
  default     = "10.0.21.0/24"
}

# ============================================================================
# APPLICATION TIER
# ============================================================================

variable "app_instance_type" {
  description = "EC2 instance type for app tier"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^t3\\.(micro|small|medium)$", var.app_instance_type))
    error_message = "Instance type must be t3.micro, t3.small, or t3.medium."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to app servers"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

# ============================================================================
# DATABASE TIER
# ============================================================================

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^db\\.t3\\.(micro|small|medium)$", var.db_instance_class))
    error_message = "Instance class must be db.t3.micro, db.t3.small, or db.t3.medium."
  }
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS (GB)"
  type        = number
  default     = 20

  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 1000
    error_message = "Allocated storage must be between 20 and 1000 GB."
  }
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]*$", var.db_name)) && length(var.db_name) <= 64
    error_message = "Database name must start with letter, contain only lowercase alphanumeric and underscores, max 64 characters."
  }
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"

  validation {
    condition     = length(var.db_username) >= 1 && length(var.db_username) <= 16
    error_message = "Username must be between 1 and 16 characters."
  }

  sensitive = true
}

variable "db_password" {
  description = "Database master password"
  type        = string

  validation {
    condition     = length(var.db_password) >= 8 && can(regex("[A-Z]", var.db_password)) && can(regex("[a-z]", var.db_password)) && can(regex("[0-9]", var.db_password))
    error_message = "Password must be at least 8 characters with uppercase, lowercase, and numbers."
  }

  sensitive = true
}
