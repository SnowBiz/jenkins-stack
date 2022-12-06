variable "region" {
    description = "AWS Deployment region"
}

variable "environment" {
    description = "Environment for networking setup"
}

variable "vpc_cidr" {
    description = "CIDR for VPC"
}

variable "public_subnets_cidr" {
    description = "CIDR for Public Subnets"
}

variable "private_subnets_cidr" {
    description = "CIDR for Private Subnets"
    type = list
}

variable "availability_zones" {
    description = "Availability Zones"
    type = list
}

variable "my_ip_address" {
    description = "My IP Address, used in SG for Jenkins access"
}