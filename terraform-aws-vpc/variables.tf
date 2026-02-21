variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "myvpc"

  validation {
    condition     = length(var.vpc_name) <= 20 && can(regex("^[a-z0-9-]+$", var.vpc_name))
    error_message = "VPC name must be lowercase alphanumeric and hyphens, max 20 characters."
  }
}

# ============================================================================
# VPC AND SUBNET CONFIGURATION
# ============================================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_1_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_2_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_3_cidr" {
  description = "CIDR block for public subnet 3"
  type        = string
  default     = "10.0.3.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_3_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.10.0/24"

  validation {
    condition     = can(cidrhost(var.private_subnet_1_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.11.0/24"

  validation {
    condition     = can(cidrhost(var.private_subnet_2_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_subnet_3_cidr" {
  description = "CIDR block for private subnet 3"
  type        = string
  default     = "10.0.12.0/24"

  validation {
    condition     = can(cidrhost(var.private_subnet_3_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

# ============================================================================
# OPTIONAL RESOURCES
# ============================================================================

variable "create_third_subnet" {
  description = "Create a third subnet pair (public/private)"
  type        = bool
  default     = false
}

# ============================================================================
# SECURITY CONFIGURATION
# ============================================================================

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}
