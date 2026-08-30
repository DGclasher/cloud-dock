output "alb_dns_names" {
  description = "ALB DNS name keyed by AWS region."
  value       = { (local.deployment_region) = module.app.alb_dns_name }
}

output "application_urls" {
  description = "HTTP application URL keyed by AWS region."
  value       = { (local.deployment_region) = module.app.application_url }
}