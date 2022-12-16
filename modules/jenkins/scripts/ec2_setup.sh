#!/bin/bash
# Ensure we are current
sudo yum update -y
# Install Ansible
sudo amazon-linux-extras install ansible2 -y
# Execute the playbook
ansible-playbook /tmp/scripts/ansible/ec2_setup_playbook.yml -e "my_hosts=localhost"