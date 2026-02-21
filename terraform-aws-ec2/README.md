# Terraform + AWS: Simple EC2 Instance Deployment

This project demonstrates deploying a simple web server EC2 instance on AWS using Terraform with a security group.

## 📋 Prerequisites

1. **AWS Account** - Sign up at [aws.amazon.com](https://aws.amazon.com)
2. **AWS CLI** - Install from [aws.amazon.com/cli](https://aws.amazon.com/cli)
3. **Terraform** - Install from [terraform.io/downloads](https://www.terraform.io/downloads)
4. **AWS Credentials** - Configure with `aws configure`

## 📁 Project Structure

```
├── main.tf           # Provider, security group, and EC2 instance
├── variables.tf      # Input variables with validation
├── outputs.tf        # Output values (IP, DNS, URLs)
├── terraform.tfvars  # Variable values (customize this)
└── README.md         # This file
```

## 🚀 Quick Start

### 1. Set Up AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region, and output format
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider and sets up the Terraform working directory.

### 3. Preview Changes

```bash
terraform plan
```

This shows what Terraform will create without actually deploying anything.

### 4. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` to confirm the deployment. This will:
- Create a security group allowing HTTP, HTTPS, and SSH
- Launch an EC2 instance with Amazon Linux 2
- Install Apache HTTP server automatically

### 5. Access Your Web Server

After deployment completes, you'll see outputs including:
- `instance_public_ip` - Direct IP address
- `instance_public_dns` - DNS name
- `website_url` - Ready-to-use URL

Open the URL in your browser to see "Hello from..." message.

## 🔧 Customization

Edit `terraform.tfvars` to change:

```hcl
aws_region       = "us-east-1"      # Change to your preferred region
instance_type    = "t3.micro"       # Free tier eligible
instance_name    = "my-web-server"  # Your custom name
allowed_ssh_cidr = "0.0.0.0/0"      # RESTRICT THIS! Use your IP instead
```

**Security Tip:** Replace `allowed_ssh_cidr` with your specific IP:
```
allowed_ssh_cidr = "YOUR.IP.ADDRESS/32"
```

Get your IP: `https://whatismyipaddress.com`

## 📊 Key Terraform Concepts in This Project

### Resources
- **aws_security_group** - Defines firewall rules (ingress/egress)
- **aws_instance** - The EC2 virtual machine
- **data.aws_ami** - Dynamically finds latest Amazon Linux 2 AMI

### Variables
- **Input variables** - Parameterize your infrastructure
- **Validation** - Ensure correct variable values
- **Defaults** - Sensible defaults for quick start

### Outputs
- Display important values after deployment
- Used by other Terraform configs or scripts
- Reference in docs and dashboards

### User Data
- `user_data` script runs on instance startup
- Updates packages and installs Apache web server
- Creates a simple index.html page

## 🧹 Cleanup

To delete all resources and avoid AWS charges:

```bash
terraform destroy
```

Type `yes` to confirm deletion.

## 📚 Learning Path Forward

After mastering this, explore:
1. **Multiple Environments** - Using workspaces for dev/staging/prod
2. **Modules** - Create reusable infrastructure components
3. **VPC** - Design complete network architectures
4. **Remote State** - Use S3 + DynamoDB for team collaboration
5. **Advanced** - Combine with Lambda, RDS, Load Balancers

## 🐛 Troubleshooting

### "Access Denied" Error
- Verify AWS credentials: `aws sts get-caller-identity`
- Ensure IAM user has EC2, VPC, and Security Group permissions

### Instance Won't Start
- Check AWS service quotas in your region
- Verify instance type availability in your region

### Can't SSH to Instance
- Check `allowed_ssh_cidr` includes your IP
- Ensure security group has SSH (port 22) ingress rule
- Verify instance is in "running" state

### Terraform State Issues
- Delete `terraform.tfstate*` and `.terraform` to reset
- Use `terraform refresh` to sync state with AWS

## 📖 Additional Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Language Reference](https://www.terraform.io/language)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [HashiCorp Learn Collections](https://learn.hashicorp.com)

---

**Happy Infrastructure Coding!** 🎯
