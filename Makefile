SHELL := /bin/bash

COMPOSE_FILE=docker/compose/docker-compose.yml
ENV_FILE=docker/compose/.env
ORACLE_TF_DIR=terraform/environments/dev

.PHONY: help
help:
	@echo "Boom Infrastructure"
	@echo "  make up"
	@echo "  make down"
	@echo "  make ps"
	@echo "  make test-local"
	@echo "  make oracle-bootstrap"
	@echo "  make oracle-doctor"
	@echo "  make oracle-init"
	@echo "  make oracle-plan"
	@echo "  make oracle-apply"

.PHONY: init-local
init-local:
	@if [ ! -f $(ENV_FILE) ]; then cp docker/compose/.env.example $(ENV_FILE); echo "Created $(ENV_FILE)"; else echo "$(ENV_FILE) already exists"; fi

.PHONY: up
up: init-local
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d

.PHONY: down
down:
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down

.PHONY: ps
ps:
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps

.PHONY: test-local
test-local:
	./scripts/local/test-local.sh

.PHONY: oracle-bootstrap
oracle-bootstrap:
	./scripts/oracle/bootstrap-terraform-vars.sh

.PHONY: oracle-doctor
oracle-doctor:
	./scripts/oracle/oracle-doctor.sh

.PHONY: oracle-init
oracle-init:
	cd $(ORACLE_TF_DIR) && terraform init

.PHONY: oracle-plan
oracle-plan:
	cd $(ORACLE_TF_DIR) && terraform plan

.PHONY: oracle-apply
oracle-apply:
	cd $(ORACLE_TF_DIR) && terraform apply

.PHONY: tf-fmt
tf-fmt:
	terraform fmt -recursive terraform
