locals {
  common_tags = merge(var.tags, {
    Module = "security-groups"
  })
}

resource "aws_security_group" "ec2" {
  name        = "${var.environment}-${var.project_name}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.project_name}-ec2-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ec2_ssh_ingress" {
  count             = length(var.allowed_ssh_cidrs) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  security_group_id = aws_security_group.ec2.id
  description       = "SSH access from allowed CIDRs"
}

resource "aws_security_group_rule" "ec2_http_ingress" {
  count             = var.allow_http ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_http_cidrs
  security_group_id = aws_security_group.ec2.id
  description       = "HTTP access"
}

resource "aws_security_group_rule" "ec2_https_ingress" {
  count             = var.allow_https ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_https_cidrs
  security_group_id = aws_security_group.ec2.id
  description       = "HTTPS access"
}

resource "aws_security_group_rule" "ec2_app_ingress" {
  count             = var.app_port != null ? 1 : 0
  type              = "ingress"
  from_port         = var.app_port
  to_port           = var.app_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_app_cidrs
  security_group_id = aws_security_group.ec2.id
  description       = "Application port access"
}

resource "aws_security_group_rule" "ec2_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
  description       = "Allow all outbound traffic"
}

resource "aws_security_group" "rds" {
  name        = "${var.environment}-${var.project_name}-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.project_name}-rds-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_ec2_ingress" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2.id
  security_group_id        = aws_security_group.rds.id
  description              = "Database access from EC2 instances"
}

resource "aws_security_group_rule" "rds_cidr_ingress" {
  count             = length(var.allowed_db_cidrs) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_db_cidrs
  security_group_id = aws_security_group.rds.id
  description       = "Database access from allowed CIDRs"
}

resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
  description       = "Allow all outbound traffic"
}
