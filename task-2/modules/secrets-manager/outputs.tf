output "secret_arn" {
  value = aws_secretsmanager_secret.app_credentials.arn
}

output "app_credentials_arn" {
  value = aws_secretsmanager_secret.app_credentials.arn
}

output "db_credentials_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "api_keys_arn" {
  value = aws_secretsmanager_secret.api_keys.arn
}

output "secret_names" {
  value = [
    aws_secretsmanager_secret.app_credentials.name,
    aws_secretsmanager_secret.db_credentials.name,
    aws_secretsmanager_secret.api_keys.name
  ]
}
