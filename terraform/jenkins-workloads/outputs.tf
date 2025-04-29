# output values

output "ec2_public_ip" {
  description = "master node public ip"
  value       = aws_instance.ec2.public_ip

}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "sonarqube_public_ip" {
  description = "sonarqube node public ip"
  value = aws_instance.sonarqube-server.public_ip
}