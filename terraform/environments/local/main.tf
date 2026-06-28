resource "docker_network" "boom" {
  name = "${var.project_name}-local-network"
}

resource "docker_volume" "postgres_data" {
  name = "${var.project_name}-local-postgres-data"
}

resource "docker_image" "postgres" {
  name         = "postgres:16-alpine"
  keep_locally = true
}

resource "docker_image" "pgadmin" {
  name         = "dpage/pgadmin4:latest"
  keep_locally = true
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "postgres" {
  name  = "${var.project_name}-local-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}"
  ]

  ports {
    internal = 5432
    external = var.postgres_port
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.boom.name
  }

  restart = "unless-stopped"
}

resource "docker_container" "pgadmin" {
  name  = "${var.project_name}-local-pgadmin"
  image = docker_image.pgadmin.image_id

  env = [
    "PGADMIN_DEFAULT_EMAIL=${var.pgadmin_email}",
    "PGADMIN_DEFAULT_PASSWORD=${var.pgadmin_password}"
  ]

  ports {
    internal = 80
    external = var.pgadmin_port
  }

  networks_advanced {
    name = docker_network.boom.name
  }

  depends_on = [docker_container.postgres]

  restart = "unless-stopped"
}

resource "docker_container" "nginx" {
  name  = "${var.project_name}-local-nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_port
  }

  upload {
    content = <<EOF
server {
    listen 80;
    server_name localhost;

    location / {
        return 200 'Boom local infrastructure is running';
        add_header Content-Type text/plain;
    }
}
EOF
    file = "/etc/nginx/conf.d/default.conf"
  }

  networks_advanced {
    name = docker_network.boom.name
  }

  restart = "unless-stopped"
}
