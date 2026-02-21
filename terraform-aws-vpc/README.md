# Terraform AWS VPC with Public & Private Subnets

Learn to design and build a complete Virtual Private Cloud (VPC) with public and private subnets, NAT Gateway for outbound internet connectivity, and internet access patterns.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                      INTERNET                       │
└──────────────────────┬──────────────────────────────┘
                       │
              ┌────────▼────────┐
              │  Internet       │
              │  Gateway (IGW)  │
              └────────┬────────┘
                       │
    ┌──────────────────┼──────────────────┐
    │                  │                  │
┌───▼──────────┐  ┌───▼──────────┐  ┌───▼──────────┐
│   PUBLIC     │  │   PUBLIC     │  │   PUBLIC     │
│  SUBNET 1    │  │  SUBNET 2    │  │  SUBNET 3    │
│ 10.0.1.0/24  │  │ 10.0.2.0/24  │  │ 10.0.3.0/24  │
│  (2 AZs + opt)  │              │  │  (optional)  │
└──────────────┘  └──────────────┘  └──────────────┘
    │                  │
    │        (NAT)     │
    │     10.0.X.X     │
    │                  │
    └──────────┬──────┬┘
               │      │
    ┌──────────▼──┐   │
    │   NAT GW    │   │
    │ Elastic IP  │   │
    └──────────┬──┘   │
               │      │
    ┌──────────▼──────▼─────────────────┐
    │   PRIVATE ROUTE TABLE             │
    │   0.0.0.0/0 → NAT Gateway         │
    └──────────┬──────┬──────────────────┘
               │      │
    ┌──────────▼──┐  ┌▼──────────┐  ┌────────────┐
    │  PRIVATE    │  │ PRIVATE   │  │  PRIVATE   │
    │ SUBNET 1    │  │ SUBNET 2  │  │  SUBNET 3  │
    │10.0.10.0/24 │  │10.0.11.0/24  │10.0.12.0/24│
    │  (No IGW)   │  │(No IGW)    │  │  (optional)│
    └─────────────┘  └───────────┘  └────────────┘
```

## 🔍 Key Concepts

### Public Subnets
- **Direct Internet Access**: Route to Internet Gateway
- **Use Cases**: Load balancers, NAT gateways, bastion hosts
- **Outbound**: Direct to IGW
- **Inbound**: Only via security groups

### Private Subnets
- **No Direct Internet**: No route to IGW
- **Outbound via NAT**: Route through NAT Gateway in public subnet
- **Use Cases**: Databases, application servers, sensitive services
- **Security**: Cannot be accessed directly from internet

### NAT Gateway
- **Location**: Resides in public subnet
- **Function**: Allows private subnets outbound internet access
- **Elasticity**: Uses Elastic IP (static public IP)
- **High Availability**: Deploy one per AZ in production

### Route Tables
- **Determine traffic flow**: Where packets go based on destination
- **Associations**: Linked to subnets to apply routing rules
- **Multiple Routes**: Can have multiple rules for different destinations

## 📊 Networking Details

| Component | Details |
|-----------|---------|
| **VPC CIDR** | 10.0.0.0/16 (65,536 IPs) |
| **Public Subnets** | 10.0.1-3.0/24 (256 IPs each) |
| **Private Subnets** | 10.0.10-12.0/24 (256 IPs each) |
| **Availability Zones** | 2-3 AZs for redundancy |
| **Internet Route** | 0.0.0.0/0 (all external traffic) |

## 📋 Prerequisites

1. **AWS Account** - With sufficient permissions
2. **AWS CLI** - Configured with credentials
3. **Terraform** - Version 1.0 or higher

## 📁 Project Files

```
├── main.tf              # VPC, subnets, gateways, route tables
├── variables.tf         # Input variables with validation
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values (customize)
└── README.md            # This file
```

## 🚀 Quick Start

### Step 1: Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region, output format
```

### Step 2: Customize Variables (Optional)

Edit `terraform.tfvars`:

```hcl
aws_region           = "us-east-1"          # Your region
vpc_name             = "myvpc"              # VPC name
vpc_cidr             = "10.0.0.0/16"        # VPC CIDR
public_subnet_1_cidr  = "10.0.1.0/24"       # Public subnet 1
public_subnet_2_cidr  = "10.0.2.0/24"       # Public subnet 2
private_subnet_1_cidr = "10.0.10.0/24"      # Private subnet 1
private_subnet_2_cidr = "10.0.11.0/24"      # Private subnet 2
create_third_subnet   = false                # Add 3rd AZ (optional)
allowed_ssh_cidr      = "YOUR_IP/32"        # Your IP for SSH
```

### Step 3: Initialize Terraform

```bash
cd terraform-aws-vpc
terraform init
```

### Step 4: Review the Plan

```bash
terraform plan
```

Shows ~20 resources including VPC, subnets, gateways, and route tables.

### Step 5: Deploy

```bash
terraform apply
```

Type `yes` to confirm. Deployment takes 1-2 minutes.

### Step 6: View Outputs

```bash
terraform output
# or specific outputs:
terraform output vpc_id
terraform output public_subnet_ids
terraform output nat_gateway_ip
```

## 🧪 Testing Your VPC

### Test 1: Verify Internet Connectivity

```bash
# Launch an EC2 in public subnet
# Should have public IP and direct internet access

# SSH to instance
ssh -i your-key.pem ec2-user@PUBLIC_IP

# From instance, test internet:
curl https://www.google.com
# Should succeed - direct internet access via IGW
```

### Test 2: Verify NAT Gateway

```bash
# Launch an EC2 in private subnet
# Should NOT have public IP

# Use bastion host or Systems Manager to connect
aws ssm start-session --target instance-id

# From instance, test internet:
curl https://www.google.com
# Should succeed - outbound via NAT Gateway

# Check outbound IP
curl https://checkip.amazonaws.com
# Should show NAT Gateway's Elastic IP
```

### Test 3: Verify Subnet Communication

```bash
# Within VPC, instances can communicate regardless of subnet
# Ping between public and private instances works (if security groups allow)
```

## 🔐 Security Considerations

### Principle of Least Privilege
- Public subnets: Only web-facing resources (ALB, NAT GW)
- Private subnets: Databases, app servers, sensitive data
- Security groups: Allow minimum required ports

### Network Isolation
```hcl
# Private subnet resources can only access internet via NAT
# Internet cannot initiate connections to private resources
# Provides strong boundary between public and private tiers
```

### NAT Gateway Costs
- Hourly charge: ~$0.045/hour per NAT Gateway
- Data processing: ~$0.045/GB for processed data
- Consider consolidating to single NAT Gateway per VPC initially

## 🔧 Customization

### Add More Subnets

Edit `variables.tf` and add:
```hcl
variable "public_subnet_4_cidr" {
  description = "CIDR block for public subnet 4"
  type        = string
  default     = "10.0.4.0/24"
}
```

Then create resource in `main.tf`:
```hcl
resource "aws_subnet" "public_4" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_4_cidr
  availability_zone       = data.aws_availability_zones.available.names[3]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-4"
    Tier = "Public"
  }
}
```

### Add Database Tier Subnets

Create a third route table with no internet access:

```hcl
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-database-rt"
    Type = "Database"
  }
}

# Associate with database subnets
resource "aws_route_table_association" "db_1" {
  subnet_id      = aws_subnet.database_1.id
  route_table_id = aws_route_table.database.id
}
```

### Enable VPC Flow Logs

```hcl
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}
```

## 🚨 Common Issues

### "InvalidSubnetID.NotFound"
- Ensure subnets are created before referencing
- Check CIDR blocks don't overlap
- Verify availability zones exist in region

### NAT Gateway Shows "Creating"
- Takes 2-3 minutes to become available
- Wait for status to change to "Available"

### Instances in Private Subnet Can't Reach Internet
- Verify NAT Gateway is in "Available" state
- Check route table has route to NAT Gateway
- Confirm security group allows outbound traffic
- Test from instance: `curl http://checkip.amazonaws.com`

### High AWS Costs
- NAT Gateway: ~$40/month per gateway + data charges
- Elastic IP: ~$3.65/month if not attached
- EC2 instances: Main cost driver
- Disable resources when not in use

## 📚 Learning Outcomes

### Network Architecture
- VPC design principles
- Public vs private network segmentation
- Multi-AZ deployment patterns
- High availability considerations

### AWS Networking
- Internet Gateway (IGW) operation
- NAT Gateway for private outbound access
- Route table configuration and association
- Subnet design and sizing (CIDR blocks)

### Terraform Advanced Concepts
- Conditional resources (count)
- Data sources (availability zones)
- Complex variable validation
- Outputs with conditional logic
- Dependencies and control flow

### Security Best Practices
- Network isolation patterns
- Security group hierarchy
- Limited internet exposure
- Internal connectivity patterns

## 📖 Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [VPC Design Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
- [NAT Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)
- [Terraform AWS VPC Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [CIDR Block Calculator](https://cidr.xyz/)

## 🧹 Cleanup

```bash
terraform destroy
```

Type `yes` to confirm. This removes all resources.

## 📋 Architecture Patterns

### 2-Tier (Web + Database)
```
Public Tier (Web)
    ↓
Private Tier (Database)
```

### 3-Tier (Web + App + Database)
```
Public Tier (ALB)
    ↓
Private Tier (App Servers)
    ↓
Private Tier (Database)
```

### Multi-Region
```
Region 1: VPC 10.0.0.0/16
Region 2: VPC 10.1.0.0/16
(Connected via VPC Peering or Transit Gateway)
```

---

**Happy VPC Designing!** 🎯

For questions, refer to AWS VPC documentation or Terraform AWS provider docs.
