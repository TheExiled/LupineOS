#!/bin/bash
set -e

echo "⚡ Initializing Sysadmin Container (admin)..."


# 2. Install Sysadmin Stack
echo "📦 Adding HashiCorp Repo for Terraform..."
distrobox enter admin -- sh -c 'sudo apt-get update && sudo apt-get install -y gnupg software-properties-common'
distrobox enter admin -- sh -c 'wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null'
distrobox enter admin -- sh -c 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list'

echo "🛠️  Installing Tools..."
distrobox enter admin -- sudo apt-get update
distrobox enter admin -- sudo apt-get install -y \
    curl wget git zsh unzip \
    nmap net-tools dnsutils whois traceroute \
    tcpdump tshark socat \
    ansible terraform \
    htop btop ncdu \
    python3 python3-pip jq
echo "☁️  Installing AWS CLI..."
distrobox enter admin -- sh -c 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip -o awscliv2.zip && sudo ./aws/install && rm awscliv2.zip'

# 4. Bridge the Shell
echo "🌉 Bridging Terminal Environment..."
distrobox enter admin -- sh -c "sudo chsh -s /usr/bin/zsh $USER"

echo "✅ Sysadmin Container Ready. Type 'distrobox enter admin' to deploy."
