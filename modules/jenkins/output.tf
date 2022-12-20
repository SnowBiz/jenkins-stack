output "jenkins_public_ip" {
  value       = "${aws_instance.web.public_ip}"
  description = "Jenkins Public IP address details"
}