# ADR-0001 - Adopt Oracle Cloud Always Free

## Status

Accepted

## Context

Boom needs a low-cost infrastructure capable of running a Java/Spring Boot backend and PostgreSQL.

## Decision

Use Oracle Cloud Infrastructure as the first cloud provider, targeting Always Free compatible resources.

## Consequences

Positive:
- Generous free-tier compute capacity
- Suitable for Docker deployment
- Good learning and experimentation platform

Trade-offs:
- OCI setup is more complex than PaaS platforms
- Free capacity may vary by region
- Terraform automation is required to reduce operational friction
