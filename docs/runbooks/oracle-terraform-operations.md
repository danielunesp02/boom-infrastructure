# Oracle Terraform Operations

## Useful commands

```bash
make oracle-bootstrap
make oracle-doctor
make oracle-init
make oracle-validate
make oracle-plan
make oracle-apply
make oracle-output
make oracle-state
make oracle-destroy
```

## Destroy partial resources

If an apply fails after creating partial resources:

```bash
make oracle-state
make oracle-destroy
```

Confirm with:

```text
yes
```

## Current strategy

Oracle is optional for now. The primary development path is local Docker first, then AWS low-cost deployment after the first functional tests.
