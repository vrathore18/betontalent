data "aws_caller_identity" "current" {}

resource "aws_secretsmanager_secret" "app_credentials" {
  name                    = "${var.project_name}/app-credentials"
  description             = "Application credentials"
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = 30

  tags = {
    Name = "${var.project_name}-app-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "app_credentials" {
  secret_id = aws_secretsmanager_secret.app_credentials.id
  secret_string = jsonencode({
    username = "app_user"
    password = "CHANGE_ME_IMMEDIATELY"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}/db-credentials"
  description             = "Database credentials"
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = 30

  tags = {
    Name = "${var.project_name}-db-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = "mysql"
    host     = "localhost"
    port     = 3306
    username = "db_user"
    password = "CHANGE_ME_IMMEDIATELY"
    dbname   = "app_db"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret" "api_keys" {
  name                    = "${var.project_name}/api-keys"
  description             = "API keys"
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = 30

  tags = {
    Name = "${var.project_name}-api-keys"
  }
}

resource "aws_secretsmanager_secret_version" "api_keys" {
  secret_id = aws_secretsmanager_secret.api_keys.id
  secret_string = jsonencode({
    api_key    = "CHANGE_ME_IMMEDIATELY"
    api_secret = "CHANGE_ME_IMMEDIATELY"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_policy" "app_credentials" {
  secret_arn = aws_secretsmanager_secret.app_credentials.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2RoleAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.ec2_role_arn
        }
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "*"
      },
      {
        Sid       = "DenyAllOthers"
        Effect    = "Deny"
        Principal = "*"
        Action    = ["secretsmanager:GetSecretValue"]
        Resource  = "*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalArn" = [
              var.ec2_role_arn,
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_secretsmanager_secret_policy" "db_credentials" {
  secret_arn = aws_secretsmanager_secret.db_credentials.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowEC2RoleAccess"
      Effect = "Allow"
      Principal = {
        AWS = var.ec2_role_arn
      }
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "*"
    }]
  })
}

resource "aws_secretsmanager_secret_policy" "api_keys" {
  secret_arn = aws_secretsmanager_secret.api_keys.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowEC2RoleAccess"
      Effect = "Allow"
      Principal = {
        AWS = var.ec2_role_arn
      }
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "*"
    }]
  })
}
