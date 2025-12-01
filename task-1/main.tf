terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.default_tags
  }
}

locals {
  name_prefix = "${var.environment}-${var.project_name}"

  default_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }

  environment_configs = {
    staging = {
      ec2_instance_type  = "t3.micro"
      rds_instance_class = "db.t3.micro"
      rds_multi_az       = false
      enable_nat         = false
    }
    production = {
      ec2_instance_type  = "t3.small"
      rds_instance_class = "db.t3.small"
      rds_multi_az       = true
      enable_nat         = true
    }
  }

  current_config = lookup(local.environment_configs, var.environment, local.environment_configs["staging"])
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = local.current_config.enable_nat

  environment  = var.environment
  project_name = var.project_name
  tags         = var.additional_tags
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id

  allowed_ssh_cidrs   = var.allowed_ssh_cidrs
  allow_http          = var.allow_http
  allowed_http_cidrs  = var.allowed_http_cidrs
  allow_https         = var.allow_https
  allowed_https_cidrs = var.allowed_https_cidrs
  app_port            = var.app_port
  allowed_app_cidrs   = var.allowed_app_cidrs

  db_port          = var.db_port
  allowed_db_cidrs = var.allowed_db_cidrs

  environment  = var.environment
  project_name = var.project_name
  tags         = var.additional_tags
}

module "ec2" {
  source = "./modules/ec2"

  instance_type      = coalesce(var.ec2_instance_type, local.current_config.ec2_instance_type)
  ami_id             = var.ec2_ami_id
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_groups.ec2_security_group_id]
  key_name           = var.ec2_key_name

  root_volume_type           = var.ec2_root_volume_type
  root_volume_size           = var.ec2_root_volume_size
  encrypt_root_volume        = var.ec2_encrypt_root_volume
  enable_detailed_monitoring = var.ec2_enable_detailed_monitoring
  user_data                  = var.ec2_user_data
  iam_instance_profile       = var.ec2_iam_instance_profile
  assign_elastic_ip          = var.ec2_assign_elastic_ip

  environment  = var.environment
  project_name = var.project_name
  tags         = var.additional_tags

  depends_on = [module.vpc, module.security_groups]
}

module "rds" {
  source = "./modules/rds"

  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  instance_class        = coalesce(var.rds_instance_class, local.current_config.rds_instance_class)
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type          = var.rds_storage_type
  storage_encrypted     = var.rds_storage_encrypted

  database_name   = var.rds_database_name
  master_username = var.rds_master_username
  master_password = var.rds_master_password
  port            = var.db_port

  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.security_groups.rds_security_group_id]
  publicly_accessible = false
  multi_az            = coalesce(var.rds_multi_az, local.current_config.rds_multi_az)

  backup_retention_period      = var.rds_backup_retention_period
  backup_window                = var.rds_backup_window
  maintenance_window           = var.rds_maintenance_window
  performance_insights_enabled = var.rds_performance_insights_enabled
  monitoring_interval          = var.rds_monitoring_interval
  deletion_protection          = var.rds_deletion_protection
  skip_final_snapshot          = var.rds_skip_final_snapshot
  auto_minor_version_upgrade   = var.rds_auto_minor_version_upgrade

  environment  = var.environment
  project_name = var.project_name
  tags         = var.additional_tags

  depends_on = [module.vpc, module.security_groups]
}
