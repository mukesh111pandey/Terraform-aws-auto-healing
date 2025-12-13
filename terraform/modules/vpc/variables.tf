variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_1_cidr" {
  type        = string
  description = "Public subnet 1 CIDR"
}

variable "public_subnet_2_cidr" {
  type        = string
  description = "Public subnet 2 CIDR"
}

variable "az1" {
  type        = string
  description = "Availability Zone 1"
}

variable "az2" {
  type        = string
  description = "Availability Zone 2"
}