# Terraform 3-Tier Application Architecture on AWS

A complete production-like infrastructure demonstrating a scalable 3-tier application architecture with load balancer, application servers, and database.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                   INTERNET (WEB TIER)               │
│            Application Load Balancer (ALB)          │
│  Public Subnets: 10.0.1.0/24, 10.0.2.0/24          │
└──────────────────┬──────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
   ┌────▼──────┐        ┌────▼──────┐
   │   EC2     │        │   EC2     │ (APP TIER)
   │ Instance1 │        │ Instance2 │
   │10.0.10.0/24        │10.0.11.0/24
   └────┬──────┘        └────┬──────┘
        └──────────┬─────────┘
                   │
        ┌──────────▼──────────┐
        │  RDS MySQL Database │  (DB TIER)
        │  Multi-AZ (2 AZs)   │
        │  Private Subnets    │
        │ 10.0.20.0/24-21.0/24
        └─────────────────────┘
```

## 📊 Components

| Tier | Component | Details |
|------|-----------|---------|
| **Web** | Application Load Balancer | Public, distributes traffic |
| **App** | 2x EC2 Instances | Private, runs Node.js application |
| **DB** | RDS MySQL | Multi-AZ, private, highly available |

## 🔒 Network Security

- **Public Subnets**: ALB only, accepts HTTP/HTTPS from internet
- **Private Subnets**: App servers, only receive traffic from ALB
- **Database Tier**: Isolated, only accessed by app tier
- **Security Group Chain**: Each tier only allows traffic from previous tier

## 📋 Prerequisites

1. **AWS Account** - With sufficient permissions
2. **AWS CLI** - Configured with credentials
3. **Terraform** - Version 1.0 or higher
4. **Linux/Mac/WSL** - For app_userdata.sh (or use Windows PowerShell ISE to convert)

## 📁 Project Files

```
├── main.tf              # VPC, networking, ALB, EC2, RDS
├── variables.tf         # Input variables with validation
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values (customize)
├── app_userdata.sh      # Boot script for EC2 instances
└── README.md            # This file
```

## 🚀 Quick Start

### Step 1: Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region, output format
```

### Step 2: Customize Variables

Edit `terraform.tfvars`:

```hcl
aws_region           = "us-east-1"          # Your region
app_name             = "myapp"              # Application name
app_instance_type    = "t3.micro"           # Free tier eligible
allowed_ssh_cidr     = "YOUR_IP/32"         # Your IP for SSH
db_instance_class    = "db.t3.micro"        # Free tier eligible
db_password          = "YourPassword123!"   # Strong password!
```

**⚠️ IMPORTANT: Change the database password and SSH CIDR!**

### Step 3: Initialize Terraform

```bash
cd terraform-aws-3tier
terraform init
```

### Step 4: Review the Plan

```bash
terraform plan
```

This shows all resources that will be created (~40+ resources).

### Step 5: Deploy

```bash
terraform apply
```

Type `yes` to confirm. Deployment takes 5-10 minutes.

### Step 6: Access Your Application

After deployment completes, Terraform outputs:
- **ALB DNS Name**: Use to access the application
- **ALB URL**: Direct HTTP URL

```bash
# From terraform outputs
open <ALB_URL>  # Mac
xdg-open <ALB_URL>  # Linux
start <ALB_URL>  # Windows PowerShell
```

You'll see a status page showing:
- Connected app instance name
- Database version
- Architecture overview

## 📚 Learning Path: What This Teaches

### 1. **VPC and Networking**
- Creating VPCs with custom CIDR blocks
- Public vs Private subnets
- Multiple Availability Zones (AZs) for redundancy
- Internet Gateway for public connectivity
- Route tables and associations
- Data sources for dynamic values

### 2. **Security**
- Security groups (stateful firewalls)
- Ingress/egress rules
- Principle of least privilege
- Network segmentation by tier
- Private database access

### 3. **Load Balancing**
- Application Load Balancer (ALB)
- Target groups
- Health checks
- Distributing traffic across instances
- DNS management

### 4. **Compute**
- EC2 instance deployment
- User data scripts for configuration
- AMI data sources
- Instance metadata

### 5. **Database**
- Managed RDS databases
- Subnet groups
- Multi-AZ deployments
- Secure database networking
- Database credentials management

### 6. **Terraform Best Practices**
- Modularizing resources
- Variable validation
- Sensitive outputs
- Data sources for dynamic values
- Organizing configuration files
- Outputs for important values

## 🔧 Customization

### Change Database Engine
Edit `main.tf`, find `aws_db_instance` resource:
```hcl
engine         = "postgres"        # Instead of mysql
engine_version = "15.2"
```

### Add More Instances
Duplicate `aws_instance` and `aws_lb_target_group_attachment` blocks:
```hcl
resource "aws_instance" "app_3" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.app_instance_type
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/app_userdata.sh", {
    db_host = aws_db_instance.main.endpoint
  }))
}
```

### Add HTTPS
```hcl
# Create SSL certificate with ACM
# Add listener on port 443
# Update ALB to use certificate
```

## 📊 Architecture Patterns Demonstrated

1. **High Availability**: Multi-AZ deployment
2. **Scalability**: Load balancer + multiple instances
3. **Security**: Network segmentation, security groups
4. **Resilience**: RDS Multi-AZ, ALB health checks
5. **Maintainability**: Organized Terraform code

## 🐛 Troubleshooting

### ALB shows "unhealthy" targets
- Check app instance user data script execution
- SSH into instance and check `/var/log/cloud-init-output.log`
- Verify security group allows ALB traffic to port 8080

### Database connection fails
- Verify security group allows app tier access on port 3306
- Check RDS endpoint format (includes `:3306` port)
- Confirm database credentials in app_userdata.sh match terraform.tfvars

### Can't SSH to app instances
- Instances are in private subnets - use AWS Systems Manager Session Manager
- Or create a bastion host in public subnet
- Or update SSH CIDR to your IP and recreate security group

### High AWS costs
- t3.micro instances are free tier only for 12 months
- RDS with multi-AZ costs more - use single AZ for testing
- Delete unused resources: `terraform destroy`

## 🧹 Cleanup

To remove all resources and stop incurring charges:

```bash
terraform destroy
```

Type `yes` to confirm. This takes 5-10 minutes.

## 📈 Next Steps

After mastering this, explore:

1. **Modules**: Extract components into reusable modules
2. **Auto Scaling**: Add Auto Scaling Group for dynamic scaling
3. **Remote State**: Store state in S3 for team collaboration
4. **CI/CD Integration**: Deploy with GitHub Actions or GitLab CI
5. **Monitoring**: Add CloudWatch, monitoring, and logging
6. **IaC Best Practices**: Workspace management, variable environments
7. **Advanced Networking**: NAT gateways, VPN, Direct Connect

## 📖 Additional Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Configuration Language](https://www.terraform.io/language)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [ALB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [HashiCorp Learn Terraform on AWS](https://learn.hashicorp.com/collections/terraform/aws)

## 📝 File Changes Reference

### main.tf
- VPC and 6 subnets across 2 AZs
- 3 route tables with proper associations
- 3 security groups with tiered access
- ALB with target group and listener
- 2 EC2 instances with user data
- RDS MySQL instance with Multi-AZ
- DB subnet group

### variables.tf
- 17 input variables
- Validation rules for all variables
- Sensitive values for passwords
- Default values for quick start

### outputs.tf
- ALB URL and DNS
- Instance IP addresses
- Database endpoint and credentials
- Security group IDs
- Architecture summary

## ⚠️ Important Notes

1. **Costs**: This deploys production-like resources. Check AWS pricing.
2. **Passwords**: Change default passwords in terraform.tfvars
3. **SSH Access**: Restrict `allowed_ssh_cidr` to your IP
4. **Database**: Passwords are stored in state file (use Secrets Manager in production)
5. **Free Tier**: Some resources may not be free tier eligible

---

**Happy Infrastructure Coding!** 🚀

For questions or issues, refer to Terraform and AWS documentation or AWS support.
