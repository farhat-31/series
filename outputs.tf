output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP - open http://<ip> in a browser"
  value       = aws_instance.web.public_ip
}
