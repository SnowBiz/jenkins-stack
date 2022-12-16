module "basic-networking" {
source = "./modules/basic-networking"
  deploy_private_subnets = "false"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  vpc_cidr               = "${var.vpc_cidr}"
  public_subnets_cidr    = "${var.public_subnets_cidr}"
  private_subnets_cidr   = "${var.private_subnets_cidr}"
  availability_zones     = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
}

module "jenkins" {
  source = "./modules/jenkins"
  allow_jenkins_ssh     = "true"
  ssh_key_name          = "my-ssh-key"
  my_ip_address         = "${var.my_ip_address}"
  vpc_id                = "${module.basic-networking.vpc_id}"
  jenkins_public_subnet = "${module.basic-networking.aws_subnet_public_az1_id}"
}