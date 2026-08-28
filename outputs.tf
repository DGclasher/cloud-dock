output "alb_dns_names" {
  description = "ALB DNS name keyed by AWS region."
  value       = { tolist(var.regions)[0] = module.app.alb_dns_name }
}

output "application_urls" {
  description = "HTTP application URL keyed by AWS region."
  value       = { tolist(var.regions)[0] = module.app.application_url }
}