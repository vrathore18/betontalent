variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH to EC2 instances"
  type        = list(string)
  default     = []
}

variable "allow_http" {
  description = "Allow HTTP traffic to EC2 instances"
  type        = bool
  default     = false
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allow_https" {
  description = "Allow HTTPS traffic to EC2 instances"
  type        = bool
  default     = false
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Custom application port to allow (optional)"
  type        = number
  default     = null
}

variable "allowed_app_cidrs" {
  description = "List of CIDR blocks allowed to access the application port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_port" {
  description = "Database port for RDS security group"
  type        = number
  default     = 3306
}

variable "allowed_db_cidrs" {
  description = "List of CIDR blocks allowed to access the database (in addition to EC2 SG)"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
