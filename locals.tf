locals {
  clouddock = yamldecode(file("${path.root}/clouddock.yaml"))

  app_config        = try(local.clouddock.application, {})
  compute_config    = try(local.clouddock.compute, {})
  database_config   = try(local.clouddock.database, { enabled = false, type = "postgres" })
  cache_config      = try(local.clouddock.cache, { enabled = false, type = "redis" })
  env_config        = try(local.clouddock.environment_variables, {})
  deployment_region = try(local.clouddock.regions[0], tolist(var.regions)[0])

  app_name       = try(local.app_config.name, var.app_name)
  docker_image   = try(local.app_config.image, var.docker_image)
  container_port = try(local.app_config.container_port, var.container_port)
  cpu            = try(local.compute_config.cpu, var.cpu)
  memory         = try(local.compute_config.memory, var.memory)
  desired_count  = try(local.compute_config.desired_count, var.desired_count)

  compute_type     = lower(try(local.compute_config.type, "ecs"))
  database_enabled = try(local.database_config.enabled, false)
  database_type    = lower(try(local.database_config.type, "postgres"))
  cache_enabled    = try(local.cache_config.enabled, false)
  cache_type       = lower(try(local.cache_config.type, "redis"))

  generated_database_env = local.database_enabled ? {
    DB_HOST     = module.database[0].host
    DB_PORT     = tostring(module.database[0].port)
    DB_NAME     = module.database[0].database_name
    DB_USERNAME = module.database[0].username
    DB_PASSWORD = module.database[0].password
  } : {}

  generated_cache_env = local.cache_enabled ? (
    local.cache_type == "redis" ? {
      REDIS_HOST = module.cache[0].host
      REDIS_PORT = tostring(module.cache[0].port)
      } : {
      MEMCACHED_HOST = module.cache[0].host
      MEMCACHED_PORT = tostring(module.cache[0].port)
    }
  ) : {}

  database_env = {
    for key, value in local.generated_database_env : key => value
    if !contains(keys(local.env_config), key)
  }

  cache_env = {
    for key, value in local.generated_cache_env : key => value
    if !contains(keys(local.env_config), key)
  }

  container_environment_variables = merge(
    local.env_config,
    local.database_env,
    local.cache_env,
  )

  database_allowed_types = ["postgres", "mysql"]
  cache_allowed_types    = ["redis", "memcached"]
}

check "compute_type_validation" {
  assert {
    condition     = local.compute_type == "ecs"
    error_message = "compute.type = 'eks' is not implemented. CloudDock currently supports only 'ecs'."
  }
}

check "database_type_validation" {
  assert {
    condition     = !local.database_enabled || contains(local.database_allowed_types, local.database_type)
    error_message = "database.type must be one of: postgres, mysql. Unsupported value: ${local.database_type}"
  }
}

check "cache_type_validation" {
  assert {
    condition     = !local.cache_enabled || contains(local.cache_allowed_types, local.cache_type)
    error_message = "cache.type must be one of: redis, memcached. Unsupported value: ${local.cache_type}"
  }
}
