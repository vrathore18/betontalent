# Get current AWS account info for resource ARNs
data "aws_caller_identity" "current" {}

# KMS keys for encryption - created first since other modules depend on it
module "kms" {
  source       = "./modules/kms"
  project_name = var.project_name
}

# VPC with public/private subnets across 2 AZs
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  kms_key_arn          = module.kms.kms_key_arn
  enable_flow_logs     = var.enable_flow_logs

  depends_on = [module.kms]
}

# Security group and VPC endpoints for private access to AWS services
module "security_group" {
  source                  = "./modules/security-group"
  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = var.vpc_cidr
  aws_region              = var.aws_region
  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
  enable_ssh              = var.key_name != ""
  allowed_ssh_cidrs       = var.allowed_ssh_cidrs

  depends_on = [module.vpc]
}

# IAM role for EC2 - follows least privilege principle
module "iam" {
  source = "./modules/iam"

  project_name  = var.project_name
  kms_key_arn   = module.kms.kms_key_arn
  s3_bucket_arn = "" # No S3 bucket access needed for now

  depends_on = [module.kms]
}

# EC2 instance in private subnet with encrypted storage
module "ec2" {
  source                     = "./modules/ec2"
  project_name               = var.project_name
  instance_type              = var.instance_type
  subnet_id                  = module.vpc.private_subnet_ids[0]
  availability_zone          = var.availability_zones[0]
  security_group_id          = module.security_group.security_group_id
  instance_profile_name      = module.iam.ec2_instance_profile_name
  key_name                   = var.key_name
  kms_key_arn                = module.kms.kms_key_arn
  ebs_kms_key_arn            = module.kms.ebs_kms_key_arn
  create_data_volume         = false
  enable_detailed_monitoring = var.enable_detailed_monitoring

  depends_on = [module.vpc, module.security_group, module.iam, module.kms]
}

# CloudTrail for API logging - disabled in dev/test if not needed
module "cloudtrail" {
  count  = var.enable_cloudtrail ? 1 : 0
  source = "./modules/cloudtrail"

  project_name  = var.project_name
  kms_key_arn   = module.kms.kms_key_arn
  force_destroy = false # Protect logs from accidental deletion

  depends_on = [module.kms]
}

# Secrets Manager for storing credentials securely
module "secrets_manager" {
  source       = "./modules/secrets-manager"
  project_name = var.project_name
  kms_key_arn  = module.kms.kms_key_arn
  ec2_role_arn = module.iam.ec2_role_arn

  depends_on = [module.kms, module.iam]
}

# AWS Config for compliance monitoring (optional - costs extra)
module "aws_config" {
  count  = var.enable_aws_config ? 1 : 0
  source = "./modules/aws-config"

  project_name  = var.project_name
  kms_key_arn   = module.kms.kms_key_arn
  force_destroy = false

  depends_on = [module.kms]
}

# CloudWatch alarms for security events - requires CloudTrail
module "cloudwatch" {
  count                     = var.enable_cloudwatch_alarms && var.enable_cloudtrail ? 1 : 0
  source                    = "./modules/cloudwatch"
  project_name              = var.project_name
  cloudtrail_log_group_name = var.enable_cloudtrail ? module.cloudtrail[0].cloudwatch_log_group_name : ""
  kms_key_id                = module.kms.kms_key_id
  alarm_email               = var.alarm_email

  depends_on = [module.cloudtrail, module.kms]
}
