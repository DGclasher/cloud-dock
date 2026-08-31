module "app" {
  source = "./modules/ecs-app"

  app_name              = local.app_name
  docker_image          = local.docker_image
  container_port        = local.container_port
  cpu                   = local.cpu
  memory                = local.memory
  desired_count         = local.desired_count
  environment_variables = local.container_environment_variables
}

module "database" {
  count  = local.database_enabled ? 1 : 0
  source = "./modules/database"

  name                  = "${local.app_name}-db"
  vpc_id                = module.app.vpc_id
  subnet_ids            = module.app.private_subnet_ids
  ecs_security_group_id = module.app.ecs_security_group_id
  database_type         = local.database_type
  username              = local.database_username
  password              = local.database_password
}

module "cache" {
  count  = local.cache_enabled ? 1 : 0
  source = "./modules/cache"

  name                  = "${local.app_name}-cache"
  vpc_id                = module.app.vpc_id
  subnet_ids            = module.app.private_subnet_ids
  ecs_security_group_id = module.app.ecs_security_group_id
  cache_type            = local.cache_type
}