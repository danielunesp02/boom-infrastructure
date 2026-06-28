# Terraform Dev Environment Runbook

## Goal

Provision the Boom development infrastructure on Oracle Cloud.

## Prerequisites

```bash
oci iam region list
make oracle-bootstrap
make oracle-doctor
```

## Validate Terraform

```bash
make tf-fmt
make oracle-init
make oracle-plan
```

## Apply

```bash
make oracle-apply
```

## Outputs

After apply, Terraform returns:

- instance public IP
- SSH command
- VCN OCID
- instance OCID

## SSH

```bash
ssh ubuntu@<public_ip>
```

## First smoke test on VM

```bash
docker ps
curl http://localhost
```

## Notes

The current dev environment is public-subnet based for simplicity. Future versions should add:

- private subnet
- firewall hardening
- DNS
- HTTPS
- backups
- monitoring
