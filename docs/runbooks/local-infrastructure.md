# Local Infrastructure Runbook

## Goal

Run Boom infrastructure locally using Docker Compose.

## Start

```bash
make up
```

This creates `docker/compose/.env` automatically if it does not exist.

## Services

| Service | URL / Port |
|---|---|
| PostgreSQL | localhost:5432 |
| pgAdmin | http://localhost:5050 |
| Nginx | http://localhost:8088 |

## Credentials

PostgreSQL:

```text
database: boom
user: boom
password: boom
```

pgAdmin:

```text
email: admin@boom.local
password: admin
```

## Validate

```bash
make ps
make test-local
curl http://localhost:8088
```

Expected response:

```text
Boom local infrastructure is running
```

## Stop

```bash
make down
```

## Logs

```bash
make logs
```
