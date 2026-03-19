#!/bin/bash
set -e

echo "Installing development tools..."

# Update package manager
apt-get update
apt-get upgrade -y

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update
apt-get install -y terraform

# Install AWS CLI
apt-get install -y awscli

# Install additional Python tools
pip install --upgrade pip
pip install pylint pytest black flake8

# Install make
apt-get install -y build-essential

echo "Development environment setup complete!"
