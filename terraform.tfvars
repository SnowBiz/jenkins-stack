# ----------------------------------------------------
# VPC / Subnet Information
# ----------------------------------------------------

region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
environment = "lab"
public_subnets_cidr = "10.0.0.0/24"
private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones = [""]

# ----------------------------------------------------
# Jenkins information
# ----------------------------------------------------

/* IP Address used for allowing access to Jenkins */
my_ip_address = "127.0.0.1/32"
ssh_key_pair_name = ""