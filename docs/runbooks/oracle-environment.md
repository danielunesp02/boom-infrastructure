# Oracle Environment Runbook

## Where to find OCI values

### tenancy_ocid
Oracle Console -> Profile menu -> Tenancy -> OCID

### user_ocid
Oracle Console -> Profile menu -> My Profile -> OCID

### fingerprint
Oracle Console -> My Profile -> API Keys -> Fingerprint

### private_key_path
Local path to the OCI API private key, usually:

```text
~/.oci/oci_api_key.pem
```

### region
Top menu region selector, for example:

```text
sa-saopaulo-1
```

### compartment_ocid
Identity & Security -> Compartments -> selected compartment -> OCID

### availability_domain

```bash
oci iam availability-domain list --compartment-id <compartment_ocid>
```

Use the `name` field.

### ssh_public_key

```bash
cat ~/.ssh/id_ed25519.pub
```

## Configure

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
code terraform.tfvars
```

## Provision

```bash
make oracle-init
make oracle-plan
make oracle-apply
```
