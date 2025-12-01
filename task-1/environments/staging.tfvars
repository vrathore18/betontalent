aws_region   = "us-east-1"
environment  = "staging"
project_name = "myapp"

additional_tags = {
  Owner      = "devops-team"
  CostCenter = "engineering"
}

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

allowed_ssh_cidrs = []

allow_http          = true
allowed_http_cidrs  = ["0.0.0.0/0"]
allow_https         = true
allowed_https_cidrs = ["0.0.0.0/0"]

allowed_db_cidrs = []
db_port          = 3306

ec2_root_volume_size           = 20
ec2_encrypt_root_volume        = true
ec2_enable_detailed_monitoring = false
ec2_assign_elastic_ip          = false

rds_engine                       = "mysql"
rds_engine_version               = "8.0"
rds_allocated_storage            = 20
rds_max_allocated_storage        = 50
rds_storage_type                 = "gp3"
rds_storage_encrypted            = true
rds_database_name                = "appdb"
rds_backup_retention_period      = 7
rds_performance_insights_enabled = false
rds_deletion_protection          = false
rds_skip_final_snapshot          = true
