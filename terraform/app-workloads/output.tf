# output values

output "ec2_public_ip" {
  description = "public ip of server"
  value       = aws_instance.yii2_app.public_ip

}

output "vpc_id" {
  value = aws_vpc.main.id
}