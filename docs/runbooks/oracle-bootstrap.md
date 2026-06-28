# Oracle Bootstrap Runbook

## Goal

Generate `terraform/environments/dev/terraform.tfvars` from the local OCI CLI configuration.

## Prerequisites

OCI CLI must be configured and authenticated:

```bash
oci iam region list
```

## Generate Terraform variables

```bash
make oracle-bootstrap
```

## Validate

```bash
make oracle-doctor
```

## Terraform

```bash
make oracle-init
make oracle-plan
make oracle-apply
```

## Security

`terraform.tfvars` must never be committed.
