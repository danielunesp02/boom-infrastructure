# Local Environment Runbook

## Start

```bash
make local-init
make local-up
```

## Validate

```bash
docker ps --filter "name=boom-"
curl http://localhost:8088
```

Expected response:

```text
Boom local infrastructure is running
```

## Database

PostgreSQL:

```text
host: localhost
port: 5432
database: boom
user: boom
password: boom
```

pgAdmin:

```text
http://localhost:5050
admin@boom.local / admin
```

## Stop

```bash
make local-down
```
