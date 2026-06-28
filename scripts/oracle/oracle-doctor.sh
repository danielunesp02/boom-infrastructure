#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${HOME}/.oci/config"
TFVARS_FILE="terraform/environments/dev/terraform.tfvars"

echo "Boom Oracle Doctor"
echo "=================="
echo

check() {
  local label="$1"
  local command="$2"
  if eval "$command" >/dev/null 2>&1; then
    echo "[OK] ${label}"
  else
    echo "[FAIL] ${label}"
    return 1
  fi
}

check "OCI CLI installed" "command -v oci"
check "OCI config exists" "test -f ${CONFIG_FILE}"
check "Terraform installed" "command -v terraform"
check "Terraform vars exists" "test -f ${TFVARS_FILE}"

KEY_FILE="$(grep '^key_file=' "${CONFIG_FILE}" | cut -d= -f2- || true)"
if [[ -n "${KEY_FILE}" ]]; then
  check "OCI private key exists" "test -f ${KEY_FILE}"
else
  echo "[FAIL] key_file not found in OCI config"
fi

echo
echo "Testing OCI authentication..."
if oci iam region list >/dev/null 2>&1; then
  echo "[OK] OCI authentication"
else
  echo "[FAIL] OCI authentication"
  echo "Run: oci iam region list --debug"
  exit 1
fi

echo
echo "Testing availability domains..."
COMPARTMENT_OCID="$(grep '^compartment_ocid' "${TFVARS_FILE}" | cut -d= -f2 | tr -d ' "')"
if oci iam availability-domain list --compartment-id "${COMPARTMENT_OCID}" >/dev/null 2>&1; then
  echo "[OK] Availability domains"
else
  echo "[FAIL] Availability domains"
  exit 1
fi

echo
echo "Oracle environment is ready."
