locals {
  common_tags = merge(var.tags, {
    Module = "rds"
  })

  db_identifier = "${var.environment}-${var.project_name}-db"
}

resource "aws_db_subnet_group" "main" {
  name        = "${local.db_identifier}-subnet-group"
  description = "Database subnet group for ${var.project_name}"
  subnet_ids  = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.db_identifier}-subnet-group"
  })
}

resource "aws_db_instance" "main" {
  identifier = local.db_identifier

  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password
  port     = var.port

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  performance_insights_enabled = var.performance_insights_enabled
  monitoring_interval          = var.monitoring_interval

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.db_identifier}-final-snapshot"

  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  tags = merge(local.common_tags, {
    Name = local.db_identifier
  })

  lifecycle {
    ignore_changes = [password]
  }
}
