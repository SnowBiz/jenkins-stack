#!/bin/bash
# Ensure we are current
sudo yum update -y
# Install Ansible
sudo amazon-linux-extras install ansible2 -y
# Install dependent tooling
sudo yum install -y wget
sudo yum install -y git
sudo yum install -y apache-maven
sudo yum install -y docker
# Jenkins
sudo amazon-linux-extras install -y java-openjdk11
sudo amazon-linux-extras install -y epel
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/7/g /etc/yum.repos.d/epel-apache-maven.repo
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo service jenkins start