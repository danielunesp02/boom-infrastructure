# ADR-0003 - Adopt Modular Terraform Structure

## Status

Accepted

## Context

Boom needs infrastructure that can evolve from a small MVP into a production-ready platform.

## Decision

Use reusable Terraform modules grouped by provider and capability.

Initial modules:

- `terraform/modules/oracle/network`
- `terraform/modules/oracle/compute`

Environment-specific configuration remains under:

- `terraform/environments/dev`

## Consequences

Positive:

- Better reuse across environments
- Cleaner separation of concerns
- Easier migration to staging/production
- More professional infrastructure foundation

Trade-offs:

- Slightly more files than a single flat Terraform script
- Requires stronger naming and variable conventions
