output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.app.dns_name
}

output "application_url" {
  description = "HTTP URL for the application."
  value       = "http://${aws_lb.app.dns_name}"
}