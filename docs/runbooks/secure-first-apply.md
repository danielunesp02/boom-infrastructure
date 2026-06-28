# Secure First Apply Runbook

## Goal

Provision the first Oracle Cloud development infrastructure using:

- dedicated `Boom` compartment
- restricted SSH access
- tagged resources
- Always Free compatible compute defaults

## Steps

```bash
make oracle-bootstrap
make oracle-doctor
make oracle-init
make oracle-plan
```

Review the plan.

Expected additions:

- project compartment
- VCN
- public subnet
- internet gateway
- route table
- security list
- compute instance

SSH should not be open to `0.0.0.0/0` unless public IP discovery failed.

## Apply

```bash
make oracle-apply
```

## Validate

```bash
ssh ubuntu@<public_ip>
docker ps
curl http://localhost
```

From your machine:

```bash
curl http://<public_ip>
```
