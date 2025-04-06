//Print out public ip
output "jenkins_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "prod_ip" {
  value = aws_instance.prod_server.public_ip
}