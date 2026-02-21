# Terraform Variables for VPC with Public and Private Subnets

aws_region = "us-east-1"
vpc_name   = "myvpc"

# VPC and Subnet Configuration
vpc_cidr              = "10.0.0.0/16"
public_subnet_1_cidr  = "10.0.1.0/24"
public_subnet_2_cidr  = "10.0.2.0/24"
public_subnet_3_cidr  = "10.0.3.0/24"
private_subnet_1_cidr = "10.0.10.0/24"
private_subnet_2_cidr = "10.0.11.0/24"
private_subnet_3_cidr = "10.0.12.0/24"

# Create third subnet pair (optional)
create_third_subnet = false

# Security Configuration
# Change to your IP for SSH access (format: YOUR_IP/32)
allowed_ssh_cidr = "0.0.0.0/0"
