# ========================================
# Network Outputs
# ========================================

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# ========================================
# Compute Outputs
# ========================================

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "security_group_id" {
  description = "ID of the main security group"
  value       = module.security_group.security_group_id
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to EC2"
  value       = module.iam.ec2_role_arn
}

# ========================================
# Security & Compliance Outputs
# ========================================

output "cloudtrail_arn" {
  description = "ARN of CloudTrail trail (null if disabled)"
  value       = var.enable_cloudtrail ? module.cloudtrail[0].cloudtrail_arn : null
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket name for CloudTrail logs"
  value       = var.enable_cloudtrail ? module.cloudtrail[0].s3_bucket_name : null
}

output "kms_key_arn" {
  description = "ARN of the main KMS key used for encryption"
  value       = module.kms.kms_key_arn
}

output "secrets_manager_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = module.secrets_manager.secret_arn
}

output "aws_config_recorder_id" {
  description = "ID of AWS Config recorder (null if disabled)"
  value       = var.enable_aws_config ? module.aws_config[0].config_recorder_id : null
}

output "cloudwatch_alarm_arns" {
  description = "List of CloudWatch security alarm ARNs"
  value       = var.enable_cloudwatch_alarms && var.enable_cloudtrail ? module.cloudwatch[0].alarm_arns : null
}
