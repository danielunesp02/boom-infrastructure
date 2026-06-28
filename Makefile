SHELL := /bin/bash

LOCAL_TF_DIR=terraform/environments/local
ORACLE_TF_DIR=terraform/environments/dev

.PHONY: help
help:
	@echo "Boom Infrastructure"
	@echo ""
	@echo "Local:"
	@echo "  make local-init"
	@echo "  make local-plan"
	@echo "  make local-up"
	@echo "  make local-down"
	@echo "  make local-status"
	@echo ""
	@echo "Oracle:"
	@echo "  make oracle-init"
	@echo "  make oracle-plan"
	@echo "  make oracle-apply"
	@echo "  make oracle-destroy"
	@echo ""
	@echo "General:"
	@echo "  make tf-fmt"
	@echo "  make check-tools"

.PHONY: local-init
local-init:
	cd $(LOCAL_TF_DIR) && terraform init

.PHONY: local-plan
local-plan:
	cd $(LOCAL_TF_DIR) && terraform plan

.PHONY: local-up
local-up:
	cd $(LOCAL_TF_DIR) && terraform apply -auto-approve

.PHONY: local-down
local-down:
	cd $(LOCAL_TF_DIR) && terraform destroy -auto-approve

.PHONY: local-status
local-status:
	docker ps --filter "name=boom-"

.PHONY: oracle-init
oracle-init:
	cd $(ORACLE_TF_DIR) && terraform init

.PHONY: oracle-plan
oracle-plan:
	cd $(ORACLE_TF_DIR) && terraform plan

.PHONY: oracle-apply
oracle-apply:
	cd $(ORACLE_TF_DIR) && terraform apply

.PHONY: oracle-destroy
oracle-destroy:
	cd $(ORACLE_TF_DIR) && terraform destroy

.PHONY: tf-fmt
tf-fmt:
	terraform fmt -recursive terraform

.PHONY: check-tools
check-tools:
	./scripts/local/check-tools.sh
