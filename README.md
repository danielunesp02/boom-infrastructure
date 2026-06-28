# Boom Infrastructure

Infrastructure repository for the Boom learning platform.

## Goals

- Reproducible infrastructure
- Cost-conscious cloud deployment
- Oracle Cloud Always Free first
- Docker-first runtime
- Terraform-managed infrastructure
- GitHub Actions validation

## Initial Architecture

```text
Oracle Cloud Infrastructure
  ├── VCN
  ├── Public Subnet
  ├── Internet Gateway
  ├── Route Table
  ├── Security List
  └── Ampere A1 Compute Instance
        ├── Docker
        ├── Docker Compose
        ├── Nginx
        ├── PostgreSQL
        └── Boom API
```

## First Setup

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Never commit `terraform.tfvars`, `.env`, private keys or OCI API keys.
