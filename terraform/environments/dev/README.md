# Oracle Dev Environment

This environment provisions the Boom development infrastructure on Oracle Cloud.

## Setup

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill the required OCI values.

## Commands

From repository root:

```bash
make oracle-init
make oracle-plan
make oracle-apply
```

## Required values

- tenancy_ocid
- user_ocid
- fingerprint
- private_key_path
- region
- compartment_ocid
- availability_domain
- ssh_public_key
