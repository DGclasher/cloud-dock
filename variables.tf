variable "regions" {
  description = "AWS region in which to deploy the application. Use one region per deployment."
  type        = set(string)
  default     = ["ap-south-1"]

  validation {
    condition     = length(var.regions) == 1 && trimspace(tolist(var.regions)[0]) != ""
    error_message = "regions must contain atleast one non-empty AWS region name."
  }
}

variable "app_name" {
  description = "Name used for ECS application resources."
  type        = string
  default     = "my-app"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,31}$", var.app_name))
    error_message = "app_name must start with a letter and contain 2-32 letters, numbers, or hyphens."
  }
}

variable "docker_image" {
  description = "Existing Docker image URI accessible by ECS."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 8080

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run per region."
  type        = number
  default     = 2

  validation {
    condition     = var.desired_count >= 1 && floor(var.desired_count) == var.desired_count
    error_message = "desired_count must be a positive whole number."
  }
}

variable "environment_variables" {
  description = "Environment variables passed to the container."
  type        = map(string)
  default     = {}
}