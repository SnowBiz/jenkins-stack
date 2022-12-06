output "instances" {
  value       = "${aws_instance.web.*.public_ip}"
  description = "Jenkins Public IP address details"
}