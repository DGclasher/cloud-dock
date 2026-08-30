variable "name" {
  description = "Logical name for the database resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the database subnet group and security group."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the database."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for the ECS tasks."
  type        = string
}

variable "database_type" {
  description = "Database engine type."
  type        = string
}

variable "username" {
  description = "Master username for the database."
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}
