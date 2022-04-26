
output "web_server_instance_id" {
  value = aws_instance.web_server.id
}

output "web_server_sg_arn" {
  value = aws_security_group.this.arn
  description = "Sec Group ARN"
}