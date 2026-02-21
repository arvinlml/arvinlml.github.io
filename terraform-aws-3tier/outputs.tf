output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_url" {
  description = "URL to access the application through ALB"
  value       = "http://${aws_lb.main.dns_name}"
}

output "app_instance_1_ip" {
  description = "Private IP of app instance 1"
  value       = aws_instance.app_1.private_ip
}

output "app_instance_2_ip" {
  description = "Private IP of app instance 2"
  value       = aws_instance.app_2.private_ip
}

output "db_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "db_host" {
  description = "RDS database host"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "db_port" {
  description = "RDS database port"
  value       = aws_db_instance.main.port
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "Private subnet 1 ID"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "Private subnet 2 ID"
  value       = aws_subnet.private_2.id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "App tier security group ID"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.db.id
}

output "architecture_summary" {
  description = "Summary of 3-tier architecture"
  value = {
    web_tier        = "ALB in public subnets (10.0.1.0/24, 10.0.2.0/24)"
    app_tier        = "EC2 instances in private subnets (10.0.10.0/24, 10.0.11.0/24)"
    database_tier   = "RDS MySQL in private subnets (10.0.20.0/24, 10.0.21.0/24)"
    high_availability = "Multi-AZ deployment with 2 app instances and 1 RDS instance"
  }
}
