variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "lambda_zip_path" {
  type        = string
  description = "Path to the prebuilt lambda zip file"
}

variable "lambda_handler" {
  type        = string
  default     = "auto_healing.lambda_handler"
  description = "Lambda handler function"
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.11"
  description = "Lambda runtime"
}

variable "sns_topic_arn" {
  type        = string
  default     = ""
  description = "SNS topic ARN to publish notifications (optional)"
}
