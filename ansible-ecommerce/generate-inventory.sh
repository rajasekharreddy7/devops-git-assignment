#!/bin/bash

if [ -z "$TERRAFORM_DEV_DIR" ]; then
    echo "ERROR: TERRAFORM_DEV_DIR is not set."
    exit 1
fi

EC2_IP=$(cd "$TERRAFORM_DEV_DIR" && terraform.exe output -raw ec2_public_ip)

if [ -z "$EC2_IP" ]; then
    echo "ERROR: Terraform did not return an EC2 IP."
    exit 1
fi

cat > inventory/hosts.ini <<INVENTORY
[dev]
web01 ansible_host=${EC2_IP}

[dev:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
INVENTORY

echo "Ansible inventory updated with EC2 IP: ${EC2_IP}"
