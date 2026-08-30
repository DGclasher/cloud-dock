output "host" {
  description = "Cache hostname."
  value       = var.cache_type == "redis" ? aws_elasticache_replication_group.redis[0].primary_endpoint_address : aws_elasticache_cluster.memcached[0].cluster_address
}

output "port" {
  description = "Cache port."
  value       = var.cache_type == "redis" ? aws_elasticache_replication_group.redis[0].port : aws_elasticache_cluster.memcached[0].port
}
