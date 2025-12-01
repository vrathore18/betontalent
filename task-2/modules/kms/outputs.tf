output "kms_key_arn" {
  value = aws_kms_key.main.arn
}

output "kms_key_id" {
  value = aws_kms_key.main.key_id
}

output "kms_key_alias" {
  value = aws_kms_alias.main.name
}

output "ebs_kms_key_arn" {
  value = aws_kms_key.ebs.arn
}

output "ebs_kms_key_id" {
  value = aws_kms_key.ebs.key_id
}
