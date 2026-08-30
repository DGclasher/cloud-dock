output "vpc_id" {
  description = "VPC ID created for the application."
  value       = aws_vpc.app.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by the ECS tasks, RDS, and ElastiCache."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "ecs_security_group_id" {
  description = "ECS task security group ID used for private DB/cache access."
  value       = aws_security_group.ecs.id
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.app.dns_name
}

output "application_url" {
  description = "HTTP URL for the application."
  value       = "http://${aws_lb.app.dns_name}"
}