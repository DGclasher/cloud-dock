variable "app_name" {
  description = "Application name used in resource names."
  type        = string
}

variable "docker_image" {
  description = "Existing Docker image URI accessible by ECS."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
}

variable "memory" {
  description = "Fargate task memory in MiB."
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks to run."
  type        = number
}

variable "environment_variables" {
  description = "Environment variables passed to the container."
  type        = map(string)
}