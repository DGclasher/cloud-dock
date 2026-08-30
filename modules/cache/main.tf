locals {
  cache_ports = {
    redis     = 6379
    memcached = 11211
  }

  cache_port = local.cache_ports[var.cache_type]
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-cache-subnets"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "this" {
  name        = "${var.name}-cache-sg"
  description = "Allow cache access from ECS tasks only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Cache access from ECS"
    protocol        = "tcp"
    from_port       = local.cache_port
    to_port         = local.cache_port
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-cache-sg"
  }
}

resource "aws_elasticache_replication_group" "redis" {
  count = var.cache_type == "redis" ? 1 : 0

  replication_group_id       = "${var.name}-redis"
  description                = "Redis cache for ${var.name}"
  engine                     = "redis"
  engine_version             = "7.1"
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 1
  port                       = 6379
  parameter_group_name       = "default.redis7"
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.this.id]
  automatic_failover_enabled = false
  transit_encryption_enabled = false
  at_rest_encryption_enabled = false

  tags = {
    Name = "${var.name}-redis"
  }
}

resource "aws_elasticache_cluster" "memcached" {
  count = var.cache_type == "memcached" ? 1 : 0

  cluster_id           = "${var.name}-memcached"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [aws_security_group.this.id]

  tags = {
    Name = "${var.name}-memcached"
  }
}
