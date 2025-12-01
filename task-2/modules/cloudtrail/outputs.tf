output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}

output "cloudtrail_id" {
  value = aws_cloudtrail.main.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.cloudtrail.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.cloudtrail.arn
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.cloudtrail.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail.name
}
