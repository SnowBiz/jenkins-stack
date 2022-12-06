# Security Group for Jenkins
resource "aws_security_group" "jenkins_allow_ssh" {
  name        = "jenkins_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${var.vpc_id}"
  count = var.allow_jenkins_ssh ? 1 : 0


  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.my_ip_address}"]
  }

  tags = {
    Name = "jenkins_allow_ssh"
  }

}

resource "aws_security_group" "jenkins_allow_http" {
  name        = "jenkins_allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "Jenkins HTTP from my IP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["${var.my_ip_address}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_allow_http"
  }
}

# Jenkins
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux2_ami.id
  instance_type = "t3.medium"
  key_name      = "${var.ssh_key_name}"
  vpc_security_group_ids = flatten([aws_security_group.jenkins_allow_http.id, var.allow_jenkins_ssh == "true" ? [aws_security_group.jenkins_allow_ssh[0].id] : []])
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install wget
sudo yum install git
sudo amazon-linux-extras install java-openjdk11
sudo amazon-linux-extras install epel -y
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/7/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo yum install -y docker
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo service jenkins start
EOF
  subnet_id = "${var.jenkins_public_subnet}"
  tags = {
    Name = "Jenkins"
  }
}