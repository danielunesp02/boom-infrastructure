SHELL := /bin/bash

COMPOSE_FILE=docker/compose/docker-compose.yml
ENV_FILE=docker/compose/.env

.PHONY: help
help:
	@echo "Boom Infrastructure"
	@echo ""
	@echo "Local commands:"
	@echo "  make init-local     Create local .env file if missing"
	@echo "  make up             Start local infrastructure"
	@echo "  make down           Stop local infrastructure"
	@echo "  make restart        Restart local infrastructure"
	@echo "  make ps             Show local containers"
	@echo "  make logs           Show local logs"
	@echo "  make test-local     Validate local services"
	@echo ""
	@echo "Terraform / Oracle:"
	@echo "  make tf-fmt"
	@echo "  make oracle-init"
	@echo "  make oracle-plan"
	@echo "  make oracle-apply"
	@echo ""
	@echo "Developer:"
	@echo "  make check-tools"

.PHONY: init-local
init-local:
	@if [ ! -f $(ENV_FILE) ]; then \
		cp docker/compose/.env.example $(ENV_FILE); \
		echo "Created $(ENV_FILE)"; \
	else \
		echo "$(ENV_FILE) already exists"; \
	fi

.PHONY: up
up: init-local
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d

.PHONY: down
down:
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down

.PHONY: restart
restart: down up

.PHONY: ps
ps:
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps

.PHONY: logs
logs:
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f

.PHONY: test-local
test-local:
	./scripts/local/test-local.sh

.PHONY: tf-fmt
tf-fmt:
	terraform fmt -recursive terraform

.PHONY: oracle-init
oracle-init:
	cd terraform/environments/dev && terraform init

.PHONY: oracle-plan
oracle-plan:
	cd terraform/environments/dev && terraform plan

.PHONY: oracle-apply
oracle-apply:
	cd terraform/environments/dev && terraform apply

.PHONY: check-tools
check-tools:
	./scripts/local/check-tools.sh
