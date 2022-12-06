variable "vpc_id" {
    description = "Specify the VPC for Jenkins to use."
}

variable "my_ip_address" {
    description = "My IP Address, used in SG for Jenkins access."
}

variable "allow_jenkins_ssh" {
    description = "If true, allow SSH access to Jenkins EC2 instance."
}

variable "ssh_key_name" {
    description = "Specify SSH key used to access Jenkins."
}

variable "jenkins_public_subnet" {
    description = "Specify the public subnet to place Jenkins in."
}