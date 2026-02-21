output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_ip" {
  description = "Elastic IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# ============================================================================
# PUBLIC SUBNETS
# ============================================================================

output "public_subnet_1_id" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public_1.id
}

output "public_subnet_1_cidr" {
  description = "CIDR block of public subnet 1"
  value       = aws_subnet.public_1.cidr_block
}

output "public_subnet_1_az" {
  description = "Availability Zone of public subnet 1"
  value       = aws_subnet.public_1.availability_zone
}

output "public_subnet_2_id" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public_2.id
}

output "public_subnet_2_cidr" {
  description = "CIDR block of public subnet 2"
  value       = aws_subnet.public_2.cidr_block
}

output "public_subnet_2_az" {
  description = "Availability Zone of public subnet 2"
  value       = aws_subnet.public_2.availability_zone
}

output "public_subnet_3_id" {
  description = "ID of public subnet 3"
  value       = try(aws_subnet.public_3[0].id, "Not created")
}

output "public_subnet_3_cidr" {
  description = "CIDR block of public subnet 3"
  value       = try(aws_subnet.public_3[0].cidr_block, "Not created")
}

output "public_subnet_ids" {
  description = "List of all public subnet IDs"
  value       = var.create_third_subnet ? [aws_subnet.public_1.id, aws_subnet.public_2.id, aws_subnet.public_3[0].id] : [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# ============================================================================
# PRIVATE SUBNETS
# ============================================================================

output "private_subnet_1_id" {
  description = "ID of private subnet 1"
  value       = aws_subnet.private_1.id
}

output "private_subnet_1_cidr" {
  description = "CIDR block of private subnet 1"
  value       = aws_subnet.private_1.cidr_block
}

output "private_subnet_1_az" {
  description = "Availability Zone of private subnet 1"
  value       = aws_subnet.private_1.availability_zone
}

output "private_subnet_2_id" {
  description = "ID of private subnet 2"
  value       = aws_subnet.private_2.id
}

output "private_subnet_2_cidr" {
  description = "CIDR block of private subnet 2"
  value       = aws_subnet.private_2.cidr_block
}

output "private_subnet_2_az" {
  description = "Availability Zone of private subnet 2"
  value       = aws_subnet.private_2.availability_zone
}

output "private_subnet_3_id" {
  description = "ID of private subnet 3"
  value       = try(aws_subnet.private_3[0].id, "Not created")
}

output "private_subnet_3_cidr" {
  description = "CIDR block of private subnet 3"
  value       = try(aws_subnet.private_3[0].cidr_block, "Not created")
}

output "private_subnet_ids" {
  description = "List of all private subnet IDs"
  value       = var.create_third_subnet ? [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3[0].id] : [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# ============================================================================
# ROUTE TABLES
# ============================================================================

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

# ============================================================================
# SECURITY GROUPS
# ============================================================================

output "security_group_ssh_id" {
  description = "ID of the SSH security group"
  value       = aws_security_group.allow_ssh.id
}

output "security_group_http_https_id" {
  description = "ID of the HTTP/HTTPS security group"
  value       = aws_security_group.allow_http_https.id
}

# ============================================================================
# NETWORK SUMMARY
# ============================================================================

output "network_summary" {
  description = "Summary of network configuration"
  value = {
    vpc_id                      = aws_vpc.main.id
    vpc_cidr                    = aws_vpc.main.cidr_block
    public_subnets             = var.create_third_subnet ? 3 : 2
    private_subnets            = var.create_third_subnet ? 3 : 2
    availability_zones_used    = var.create_third_subnet ? 3 : 2
    internet_gateway_attached  = true
    nat_gateway_attached       = true
    nat_gateway_ip             = aws_eip.nat.public_ip
  }
}
