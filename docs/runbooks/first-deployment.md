# First Deployment Runbook

## 1. Prepare tools

Required:

- Terraform
- OCI CLI
- Docker
- GitHub CLI
- SSH key pair

## 2. Prepare variables

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
```

## 3. Validate

```bash
terraform init
terraform fmt
terraform validate
terraform plan
```

## 4. Apply

```bash
terraform apply
```

## 5. SSH

```bash
ssh ubuntu@<public_ip>
```
