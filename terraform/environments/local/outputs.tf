output "postgres_connection" {
  value = "postgresql://${var.postgres_user}:***@localhost:${var.postgres_port}/${var.postgres_db}"
}

output "pgadmin_url" {
  value = "http://localhost:${var.pgadmin_port}"
}

output "nginx_url" {
  value = "http://localhost:${var.nginx_port}"
}
