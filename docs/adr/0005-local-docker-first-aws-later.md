# ADR-0005 - Adopt Local Docker First and AWS Later

## Status

Accepted

## Context

Oracle Cloud Always Free is attractive, but the ARM free-tier capacity may be unavailable in the chosen region. Docker Desktop also has compatibility constraints on older macOS versions.

## Decision

Prioritize a local Docker-based development runtime. After the first functional tests, deploy to AWS using the smallest reasonable paid tier.

Oracle Cloud remains optional and can be retried later.

## Consequences

Positive:

- Faster product development
- Less dependency on provider capacity
- Easier local feedback loop
- Clear path to AWS later

Trade-offs:

- Requires resolving Docker daemon availability on the development machine
- AWS will likely introduce a small monthly cost
