output "instance_id" {
  value = aws_instance.main.id
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "instance_arn" {
  value = aws_instance.main.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ec2.name
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.ec2.arn
}
