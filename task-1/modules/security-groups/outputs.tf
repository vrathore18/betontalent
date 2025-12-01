output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "ec2_security_group_arn" {
  description = "The ARN of the EC2 security group"
  value       = aws_security_group.ec2.arn
}

output "ec2_security_group_name" {
  description = "The name of the EC2 security group"
  value       = aws_security_group.ec2.name
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "rds_security_group_arn" {
  description = "The ARN of the RDS security group"
  value       = aws_security_group.rds.arn
}

output "rds_security_group_name" {
  description = "The name of the RDS security group"
  value       = aws_security_group.rds.name
}
