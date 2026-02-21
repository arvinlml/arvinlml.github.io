# Terraform Variables for 3-Tier Application
# Customize these values for your deployment

aws_region = "us-east-1"
app_name   = "myapp"

# VPC and Networking
vpc_cidr              = "10.0.0.0/16"
public_subnet_1_cidr  = "10.0.1.0/24"
public_subnet_2_cidr  = "10.0.2.0/24"
private_subnet_1_cidr = "10.0.10.0/24"
private_subnet_2_cidr = "10.0.11.0/24"
db_subnet_1_cidr      = "10.0.20.0/24"
db_subnet_2_cidr      = "10.0.21.0/24"

# Application Tier
app_instance_type = "t3.micro"
allowed_ssh_cidr  = "YOUR_IP/32"  # Change to your IP for SSH access

# Database Tier
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "appdb"
db_username          = "admin"
db_password          = "ChangeMe123!"  # Change to a strong password
