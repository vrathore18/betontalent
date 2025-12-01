output "config_recorder_id" {
  value = aws_config_configuration_recorder.main.id
}

output "config_role_arn" {
  value = aws_iam_role.config.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.config.id
}

output "config_rules" {
  value = [
    aws_config_config_rule.ebs_encryption.name,
    aws_config_config_rule.s3_public_access.name,
    aws_config_config_rule.s3_encryption.name,
    aws_config_config_rule.ec2_imdsv2.name,
    aws_config_config_rule.vpc_flow_logs.name,
    aws_config_config_rule.cloudtrail_enabled.name,
    aws_config_config_rule.root_mfa.name,
    aws_config_config_rule.iam_user_mfa.name,
    aws_config_config_rule.iam_credentials_unused.name,
    aws_config_config_rule.sg_ssh_restricted.name
  ]
}
