# WSL Quick Reference - Common Commands

## Connecting to WSL in VS Code

### Method 1: Command Palette
```
Ctrl+Shift+P > WSL: Reopen in WSL
```

### Method 2: PowerShell
```powershell
code --remote wsl+Ubuntu .
```

### Method 3: PowerShell Script
```powershell
.\setup-wsl.ps1
```

## Managing WSL from Windows PowerShell

### List all WSL distributions
```powershell
wsl --list -v
```

### Open WSL terminal
```powershell
wsl
```

### Run a command in WSL from Windows
```powershell
wsl python3 4dSaiProps.py
wsl terraform -v
wsl aws --version
```

### Access your project in WSL
```powershell
# From Windows PowerShell
wsl cd /mnt/c/Users/arvin/Source/arvinlml.github.io
```

## Working Inside WSL Terminal

### Navigate to your project
```bash
cd /mnt/c/Users/arvin/Source/arvinlml.github.io
```

### Python Development
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run Python script
python3 4dSaiProps.py
python3 mergePdf.py
```

### Terraform Operations
```bash
cd terraform-aws-vpc
terraform init
terraform plan
terraform apply
```

### AWS CLI Operations
```bash
# Configure AWS credentials
aws configure

# List S3 buckets
aws s3 ls

# Deploy infrastructure
aws cloudformation deploy --template-file template.json --stack-name my-stack
```

### Git Operations
```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Clone, add, commit
git add .
git commit -m "Your message"
git push
```

## Useful WSL Features

### Copy files between Windows and WSL
```bash
# From Windows to WSL
cp /mnt/c/Users/arvin/file.txt ~/file.txt

# From WSL to Windows
cp ~/file.txt /mnt/c/Users/arvin/file.txt
```

### Open WSL folder in Windows Explorer
```bash
explorer.exe .
```

### Install additional packages in WSL
```bash
sudo apt update
sudo apt install package-name
```

### Check Python version in WSL
```bash
python3 --version
```

### List installed Python packages
```bash
pip list
```

## Troubleshooting

### WSL Extension Not Showing
- Make sure Remote - WSL extension is installed: `code --install-extension ms-vscode-remote.remote-wsl`
- Reload VS Code window

### Permission Denied Errors
```bash
chmod +x script.sh
```

### Slow WSL Performance
- Keep files on Windows filesystem, not in WSL root
- Use `/mnt/c/...` paths for better performance

### Update WSL
```powershell
wsl --update
wsl --update rollback  # rollback if needed
```

## Additional Resources

- [VS Code Remote - WSL Docs](https://code.visualstudio.com/docs/remote/wsl)
- [WSL Official Documentation](https://learn.microsoft.com/en-us/windows/wsl/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/)
