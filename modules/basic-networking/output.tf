/* 
Access in another submodule:
vpc_cidr             = "${module.basic-networking.vpc_id}"
*/
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "aws_subnet_public_az1_id" {
  value = "${aws_subnet.public_subnet_az1.id}"
}