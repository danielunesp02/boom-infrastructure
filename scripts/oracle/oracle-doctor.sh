#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${HOME}/.oci/config"
TF_DIR="terraform/environments/dev"
TFVARS_FILE="${TF_DIR}/terraform.tfvars"

echo "Boom Oracle Doctor"
echo "=================="
echo

failures=0

check() {
  local label="$1"
  local command="$2"

  if eval "$command" >/dev/null 2>&1; then
    echo "[OK] ${label}"
  else
    echo "[FAIL] ${label}"
    failures=$((failures + 1))
  fi
}

check "OCI CLI installed" "command -v oci"
check "OCI config exists" "test -f ${CONFIG_FILE}"
check "Terraform installed" "command -v terraform"
check "Terraform environment directory exists" "test -d ${TF_DIR}"
check "Terraform vars exists" "test -f ${TFVARS_FILE}"

if [[ -f "${CONFIG_FILE}" ]]; then
  KEY_FILE="$(grep '^key_file=' "${CONFIG_FILE}" | cut -d= -f2- || true)"
  REGION="$(grep '^region=' "${CONFIG_FILE}" | cut -d= -f2- || true)"
  TENANCY="$(grep '^tenancy=' "${CONFIG_FILE}" | cut -d= -f2- || true)"
  echo
  echo "OCI config:"
  echo "  region: ${REGION:-missing}"
  echo "  key_file: ${KEY_FILE:-missing}"
  echo "  tenancy present: $([[ -n "${TENANCY:-}" ]] && echo yes || echo no)"

  if [[ -n "${KEY_FILE:-}" ]]; then
    check "OCI private key exists" "test -f ${KEY_FILE}"
    check "OCI private key permissions readable" "test -r ${KEY_FILE}"
  fi
fi

echo
echo "Testing OCI authentication..."
if oci iam region list >/dev/null 2>&1; then
  echo "[OK] OCI authentication"
else
  echo "[FAIL] OCI authentication"
  failures=$((failures + 1))
fi

if [[ -f "${TFVARS_FILE}" ]]; then
  echo
  echo "Testing availability domains..."
  COMPARTMENT_OCID="$(grep '^compartment_ocid' "${TFVARS_FILE}" | cut -d= -f2 | tr -d ' "' || true)"
  if [[ -n "${COMPARTMENT_OCID}" ]] && oci iam availability-domain list --compartment-id "${COMPARTMENT_OCID}" >/dev/null 2>&1; then
    echo "[OK] Availability domains"
  else
    echo "[FAIL] Availability domains"
    failures=$((failures + 1))
  fi
fi

echo
if [[ "${failures}" -eq 0 ]]; then
  echo "Oracle environment is ready."
else
  echo "Oracle environment has ${failures} issue(s)."
  exit 1
fi
