# ADR-0004 - Dedicated OCI Compartment and SSH Allowlist

## Status

Accepted

## Context

The first Terraform plan created Boom resources directly inside the tenancy root compartment and allowed SSH from `0.0.0.0/0`.

This is acceptable for a quick experiment, but not a good long-term foundation.

## Decision

Create a dedicated `Boom` compartment managed by Terraform and restrict SSH access using `allowed_ssh_cidrs`.

Initial SSH CIDR is generated from the developer's public IP using:

```bash
curl https://api.ipify.org
```

## Consequences

Positive:

- Better resource isolation
- Cleaner cost and resource management
- Lower attack surface for SSH
- Better foundation for staging/production

Trade-offs:

- Slightly more Terraform complexity
- If the developer's public IP changes, `allowed_ssh_cidrs` must be updated
