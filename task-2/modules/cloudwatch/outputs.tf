output "sns_topic_arn" {
  value = aws_sns_topic.security_alerts.arn
}

output "alarm_arns" {
  value = [
    aws_cloudwatch_metric_alarm.root_usage.arn,
    aws_cloudwatch_metric_alarm.unauthorized_api_calls.arn,
    aws_cloudwatch_metric_alarm.iam_changes.arn,
    aws_cloudwatch_metric_alarm.security_group_changes.arn,
    aws_cloudwatch_metric_alarm.nacl_changes.arn,
    aws_cloudwatch_metric_alarm.console_signin_failures.arn,
    aws_cloudwatch_metric_alarm.cloudtrail_changes.arn,
    aws_cloudwatch_metric_alarm.vpc_changes.arn,
    aws_cloudwatch_metric_alarm.kms_changes.arn,
    aws_cloudwatch_metric_alarm.s3_bucket_policy_changes.arn
  ]
}

output "alarm_names" {
  value = [
    aws_cloudwatch_metric_alarm.root_usage.alarm_name,
    aws_cloudwatch_metric_alarm.unauthorized_api_calls.alarm_name,
    aws_cloudwatch_metric_alarm.iam_changes.alarm_name,
    aws_cloudwatch_metric_alarm.security_group_changes.alarm_name,
    aws_cloudwatch_metric_alarm.nacl_changes.alarm_name,
    aws_cloudwatch_metric_alarm.console_signin_failures.alarm_name,
    aws_cloudwatch_metric_alarm.cloudtrail_changes.alarm_name,
    aws_cloudwatch_metric_alarm.vpc_changes.alarm_name,
    aws_cloudwatch_metric_alarm.kms_changes.alarm_name,
    aws_cloudwatch_metric_alarm.s3_bucket_policy_changes.alarm_name
  ]
}
