variable "project_suffix" {
  description = "Unique suffix for bucket names"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_user" {
  description = "RDS database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS database master password"
  type        = string
  sensitive   = true
}
