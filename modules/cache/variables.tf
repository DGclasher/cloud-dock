variable "name" {
  description = "Logical name for the cache resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the cache deployment."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the cache cluster."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for the ECS tasks."
  type        = string
}

variable "cache_type" {
  description = "Cache engine type."
  type        = string
}
