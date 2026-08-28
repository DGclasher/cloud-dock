module "app" {
  source = "./modules/ecs-app"

  app_name              = var.app_name
  docker_image          = var.docker_image
  container_port        = var.container_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count
  environment_variables = var.environment_variables
}