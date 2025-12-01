variable "project_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "key_name" {
  type    = string
  default = ""
}

variable "kms_key_arn" {
  type = string
}

variable "ebs_kms_key_arn" {
  type = string
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "create_data_volume" {
  type    = bool
  default = false
}

variable "data_volume_size" {
  type    = number
  default = 50
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = true
}
