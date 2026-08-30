output "host" {
  description = "Database hostname."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Database port."
  value       = aws_db_instance.this.port
}

output "database_name" {
  description = "Database name."
  value       = aws_db_instance.this.db_name
}

output "username" {
  description = "Database master username."
  value       = aws_db_instance.this.username
}

output "password" {
  description = "Database master password."
  value       = aws_db_instance.this.password
  sensitive   = true
}
