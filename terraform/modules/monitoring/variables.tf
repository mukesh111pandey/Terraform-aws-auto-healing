variable "project" {
  description = "Project name"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

variable "alarm_email" {
  description = "Email for alarm notifications"
  type        = string
}
