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

variable "deploy_private_subnets" {
    description = "Specify if private subnets with nat gateway are to be deployed"
}