variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. If empty, uses latest Amazon Linux 2"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the SSH key pair for instance access"
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "Root volume type (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "encrypt_root_volume" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script for instance initialization"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for the EC2 instance"
  type        = string
  default     = null
}

variable "assign_elastic_ip" {
  description = "Assign an Elastic IP to the instance"
  type        = bool
  default     = false
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
