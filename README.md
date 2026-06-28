# Boom Infrastructure

This repository supports two official execution modes:

```text
local  -> Docker containers created locally
dev    -> Oracle Cloud Infrastructure using Terraform
```

## Local mode

Use this when developing on your Mac.

```bash
make local-up
make local-status
make local-down
```

Services:

- PostgreSQL: `localhost:5432`
- pgAdmin: `http://localhost:5050`
- Nginx: `http://localhost:8088`

## Oracle dev mode

Use this when provisioning the development environment in Oracle Cloud.

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# fill terraform.tfvars
cd ../../..
make oracle-init
make oracle-plan
make oracle-apply
```

## Important

Do not commit:

- `terraform.tfvars`
- `.env`
- private keys
- OCI API keys
