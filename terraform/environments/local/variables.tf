variable "project_name" {
  type    = string
  default = "boom"
}

variable "postgres_db" {
  type    = string
  default = "boom"
}

variable "postgres_user" {
  type    = string
  default = "boom"
}

variable "postgres_password" {
  type      = string
  default   = "boom"
  sensitive = true
}

variable "postgres_port" {
  type    = number
  default = 5432
}

variable "pgadmin_email" {
  type    = string
  default = "admin@boom.local"
}

variable "pgadmin_password" {
  type      = string
  default   = "admin"
  sensitive = true
}

variable "pgadmin_port" {
  type    = number
  default = 5050
}

variable "nginx_port" {
  type    = number
  default = 8088
}
