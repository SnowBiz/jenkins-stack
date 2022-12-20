output "jenkins_admin_console_url" {
  value       = "http://${module.jenkins.jenkins_public_ip}:8080"
  description = "Jenkins admin console URL"
}

output "jenkins_sg_allowed_cidr" {
  value       = "${var.my_ip_address}"
  description = "Jenkins SSH and web access allowed IP address"
}