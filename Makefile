SHELL := /bin/bash
TF_DEV_DIR=terraform/environments/dev

.PHONY: help tf-init tf-fmt tf-validate tf-plan tf-apply local-up local-down check-tools

help:
	@echo "Boom Infrastructure commands"
	@echo "  make tf-init"
	@echo "  make tf-fmt"
	@echo "  make tf-validate"
	@echo "  make tf-plan"
	@echo "  make tf-apply"
	@echo "  make local-up"
	@echo "  make local-down"
	@echo "  make check-tools"

tf-init:
	cd $(TF_DEV_DIR) && terraform init

tf-fmt:
	terraform fmt -recursive terraform

tf-validate:
	cd $(TF_DEV_DIR) && terraform validate

tf-plan:
	cd $(TF_DEV_DIR) && terraform plan

tf-apply:
	cd $(TF_DEV_DIR) && terraform apply

local-up:
	docker compose -f docker/local/docker-compose.yml up -d

local-down:
	docker compose -f docker/local/docker-compose.yml down

check-tools:
	./scripts/local/check-tools.sh
