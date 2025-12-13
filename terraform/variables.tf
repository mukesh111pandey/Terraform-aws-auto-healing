variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "auto-healing"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "lambda_zip_path" {
  description = "Path to Lambda zip file"
  type        = string
  default     = "modules/lambda/auto_healing.zip"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "auto_healing.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "sns_topic_arn" {
  description = "SNS topic ARN (optional)"
  type        = string
  default     = ""
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}
