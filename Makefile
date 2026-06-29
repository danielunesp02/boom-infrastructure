SHELL := /bin/bash

COMPOSE_FILE=docker/compose/docker-compose.yml
ENV_FILE=docker/compose/.env
ORACLE_TF_DIR=terraform/environments/dev

.PHONY: help
help:
	@echo "Boom Infrastructure"
	@echo ""
	@echo "Local Docker:"
	@echo "  make init-local       Create local .env if missing"
	@echo "  make up               Start local stack"
	@echo "  make down             Stop local stack"
	@echo "  make restart          Restart local stack"
	@echo "  make ps               Show local containers"
	@echo "  make logs             Tail all local logs"
	@echo "  make test-local       Smoke test local stack"
	@echo "  make clean-local      Remove local containers and volumes"
	@echo ""
	@echo "Oracle Terraform:"
	@echo "  make oracle-bootstrap Generate terraform.tfvars from OCI config"
	@echo "  make oracle-doctor    Validate OCI/Terraform setup"
	@echo "  make oracle-init      Terraform init"
	@echo "  make oracle-validate  Terraform validate"
	@echo "  make oracle-plan      Terraform plan"
	@echo "  make oracle-apply     Terraform apply"
	@echo "  make oracle-destroy   Terraform destroy"
	@echo "  make oracle-state     Terraform state list"
	@echo "  make oracle-output    Terraform output"
	@echo "  make oracle-refresh   Terraform refresh"
	@echo ""
	@echo "General:"
	@echo "  make tf-fmt"
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

.PHONY: clean-local
clean-local:
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down -v --remove-orphans

.PHONY: oracle-bootstrap
oracle-bootstrap:
	./scripts/oracle/bootstrap-terraform-vars.sh

.PHONY: oracle-doctor
oracle-doctor:
	./scripts/oracle/oracle-doctor.sh

.PHONY: oracle-init
oracle-init:
	cd $(ORACLE_TF_DIR) && terraform init

.PHONY: oracle-validate
oracle-validate:
	cd $(ORACLE_TF_DIR) && terraform validate

.PHONY: oracle-plan
oracle-plan:
	cd $(ORACLE_TF_DIR) && terraform plan

.PHONY: oracle-apply
oracle-apply:
	cd $(ORACLE_TF_DIR) && terraform apply

.PHONY: oracle-destroy
oracle-destroy:
	cd $(ORACLE_TF_DIR) && terraform destroy

.PHONY: oracle-state
oracle-state:
	cd $(ORACLE_TF_DIR) && terraform state list

.PHONY: oracle-output
oracle-output:
	cd $(ORACLE_TF_DIR) && terraform output

.PHONY: oracle-refresh
oracle-refresh:
	cd $(ORACLE_TF_DIR) && terraform refresh

.PHONY: tf-fmt
tf-fmt:
	terraform fmt -recursive terraform

.PHONY: check-tools
check-tools:
	./scripts/local/check-tools.sh
