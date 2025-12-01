aws_region   = "us-east-1"
environment  = "production"
project_name = "myapp"

additional_tags = {
  Owner       = "devops-team"
  CostCenter  = "engineering"
  Criticality = "high"
}

vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

allowed_ssh_cidrs = []

allow_http          = true
allowed_http_cidrs  = ["0.0.0.0/0"]
allow_https         = true
allowed_https_cidrs = ["0.0.0.0/0"]

allowed_db_cidrs = []
db_port          = 3306

ec2_root_volume_size           = 50
ec2_encrypt_root_volume        = true
ec2_enable_detailed_monitoring = true
ec2_assign_elastic_ip          = true

rds_engine                       = "mysql"
rds_engine_version               = "8.0"
rds_allocated_storage            = 50
rds_max_allocated_storage        = 200
rds_storage_type                 = "gp3"
rds_storage_encrypted            = true
rds_database_name                = "appdb"
rds_backup_retention_period      = 30
rds_backup_window                = "03:00-04:00"
rds_maintenance_window           = "Sun:04:00-Sun:05:00"
rds_performance_insights_enabled = true
rds_monitoring_interval          = 60
rds_deletion_protection          = true
rds_skip_final_snapshot          = false
rds_auto_minor_version_upgrade   = false
