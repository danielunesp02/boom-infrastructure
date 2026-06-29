# Local Docker Runtime

## Goal

Run the local Boom infrastructure using Docker Compose.

## Services

| Service | Address |
|---|---|
| PostgreSQL | localhost:5432 |
| Redis | localhost:6379 |
| pgAdmin | http://localhost:5050 |
| Nginx | http://localhost:8088 |

## Start

```bash
make up
```

## Validate

```bash
make ps
make test-local
```

Expected response from Nginx:

```text
Boom local infrastructure is running
```

## Stop

```bash
make down
```

## Clean everything

```bash
make clean-local
```

This removes containers and volumes.

## Notes

The backend is not yet part of the compose stack. Once `boom-backend` is created, it will be added as a service and Nginx will route `/api` to it.
