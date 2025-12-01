variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be either 'staging' or 'production'."
  }
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "myapp"
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH to EC2 instances"
  type        = list(string)
  default     = []
}

variable "allow_http" {
  description = "Allow HTTP traffic to EC2 instances"
  type        = bool
  default     = true
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allow_https" {
  description = "Allow HTTPS traffic to EC2 instances"
  type        = bool
  default     = true
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Custom application port (optional)"
  type        = number
  default     = null
}

variable "allowed_app_cidrs" {
  description = "List of CIDR blocks allowed to access the application port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "allowed_db_cidrs" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "ec2_instance_type" {
  description = "EC2 instance type (overrides environment default if set)"
  type        = string
  default     = null
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instance (uses latest Amazon Linux 2 if empty)"
  type        = string
  default     = ""
}

variable "ec2_key_name" {
  description = "Name of the SSH key pair for EC2 access"
  type        = string
  default     = null
}

variable "ec2_root_volume_type" {
  description = "EC2 root volume type"
  type        = string
  default     = "gp3"
}

variable "ec2_root_volume_size" {
  description = "EC2 root volume size in GB"
  type        = number
  default     = 20
}

variable "ec2_encrypt_root_volume" {
  description = "Encrypt EC2 root volume"
  type        = bool
  default     = true
}

variable "ec2_enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring for EC2"
  type        = bool
  default     = false
}

variable "ec2_user_data" {
  description = "User data script for EC2 initialization"
  type        = string
  default     = null
}

variable "ec2_iam_instance_profile" {
  description = "IAM instance profile for EC2"
  type        = string
  default     = null
}

variable "ec2_assign_elastic_ip" {
  description = "Assign Elastic IP to EC2 instance"
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "8.0"
}

variable "rds_instance_class" {
  description = "RDS instance class (overrides environment default if set)"
  type        = string
  default     = null
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "RDS maximum allocated storage for autoscaling in GB"
  type        = number
  default     = 100
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "rds_storage_encrypted" {
  description = "Enable RDS storage encryption"
  type        = bool
  default     = true
}

variable "rds_database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "appdb"
}

variable "rds_master_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "rds_master_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ for RDS (overrides environment default if set)"
  type        = bool
  default     = null
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period in days"
  type        = number
  default     = 7
}

variable "rds_backup_window" {
  description = "RDS preferred backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "rds_maintenance_window" {
  description = "RDS preferred maintenance window (UTC)"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "rds_performance_insights_enabled" {
  description = "Enable RDS Performance Insights"
  type        = bool
  default     = false
}

variable "rds_monitoring_interval" {
  description = "RDS enhanced monitoring interval in seconds"
  type        = number
  default     = 0
}

variable "rds_deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS"
  type        = bool
  default     = true
}

variable "rds_auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades for RDS"
  type        = bool
  default     = true
}
