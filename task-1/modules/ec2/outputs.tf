output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.main.arn
}

output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.main.private_ip
}

output "public_ip" {
  description = "The public IP address of the EC2 instance (if assigned)"
  value       = aws_instance.main.public_ip
}

output "elastic_ip" {
  description = "The Elastic IP address (if assigned)"
  value       = var.assign_elastic_ip ? aws_eip.main[0].public_ip : null
}

output "private_dns" {
  description = "The private DNS name of the EC2 instance"
  value       = aws_instance.main.private_dns
}

output "public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "availability_zone" {
  description = "The availability zone of the EC2 instance"
  value       = aws_instance.main.availability_zone
}

output "ami_id" {
  description = "The AMI ID used for the EC2 instance"
  value       = aws_instance.main.ami
}

output "instance_state" {
  description = "The state of the EC2 instance"
  value       = aws_instance.main.instance_state
}
