variable "project_name" {
  type = string
}

variable "cloudtrail_log_group_name" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "alarm_email" {
  type    = string
  default = ""
}
