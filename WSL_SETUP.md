# WSL Integration Guide

This workspace is configured to work with Windows Subsystem for Linux (WSL) running Ubuntu.

## Quick Start

### 1. Open Project in WSL
- Press `Ctrl+Shift+P` to open the Command Palette
- Type "WSL: Reopen in WSL"
- VS Code will connect to your Ubuntu WSL environment

### 2. Verify WSL Connection
Once connected, you'll see "WSL: Ubuntu" in the bottom-left corner of VS Code.

## WSL Prerequisites

Ensure you have the following installed in your WSL Ubuntu environment:

```bash
# Update package manager
sudo apt update && sudo apt upgrade -y

# Install Python and packages
sudo apt install -y python3 python3-pip python3-venv

# Install Node.js (optional, if needed)
sudo apt install -y nodejs npm

# Install Terraform (for AWS infrastructure projects)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Install AWS CLI
sudo apt install -y awscli

# Install Git
sudo apt install -y git
```

## Environment Setup

### Python Virtual Environment (in WSL)
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt  # if you have a requirements.txt
```

### Working with Your Projects

#### Python Scripts
- `4dSaiProps.py` - Available in WSL terminal
- `mergePdf.py` - Available in WSL terminal

#### Terraform Projects
- `terraform-aws-vpc/` - Deploy with `terraform plan` and `terraform apply`
- `terraform-aws-ec2/` - AWS EC2 configuration
- `terraform-aws-3tier/` - 3-tier AWS architecture

Run Terraform within WSL:
```bash
cd terraform-aws-vpc
terraform init
terraform plan
terraform apply
```

## Tips

1. **File Access**: Your Windows files are available at `/mnt/c/Users/arvin/Source/arvinlml.github.io/` in WSL
2. **Performance**: Keep your project files on the Windows filesystem for best performance with VS Code Remote
3. **Terminal**: Use the integrated terminal (Ctrl+`) when connected to WSL - it automatically uses the WSL environment
4. **Git**: Configure git in WSL if not already done:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

## Disconnecting from WSL

To switch back to local development:
- Press `Ctrl+Shift+P`
- Type "Remote-Containers: Reopen Locally"

## Troubleshooting

### WSL Not Found
- Ensure WSL 2 is installed and Ubuntu is selected as default
- Run `wsl --list -v` in PowerShell to verify

### Slow Performance
- Keep your project on the Windows filesystem (not in WSL root)
- Avoid heavy I/O operations within WSL filesystem

### Extensions Not Loading
- Some extensions may need to be installed per-environment
- Install required extensions in WSL when prompted

## Additional Resources

- [VS Code Remote - WSL Documentation](https://code.visualstudio.com/docs/remote/wsl)
- [WSL Documentation](https://learn.microsoft.com/en-us/windows/wsl/)
- [Terraform on AWS](https://learn.hashicorp.com/tutorials/terraform/aws-build)
