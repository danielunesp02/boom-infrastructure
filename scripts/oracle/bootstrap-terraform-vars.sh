#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${HOME}/.oci/config"
TF_DIR="terraform/environments/dev"
TFVARS_FILE="${TF_DIR}/terraform.tfvars"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "[ERROR] OCI config not found at ${CONFIG_FILE}"
  echo "Run: oci setup config"
  exit 1
fi

get_config_value() {
  local key="$1"
  grep "^${key}=" "${CONFIG_FILE}" | head -n 1 | cut -d= -f2-
}

USER_OCID="$(get_config_value user)"
TENANCY_OCID="$(get_config_value tenancy)"
FINGERPRINT="$(get_config_value fingerprint)"
PRIVATE_KEY_PATH="$(get_config_value key_file)"
REGION="$(get_config_value region)"

if [[ -z "${USER_OCID}" || -z "${TENANCY_OCID}" || -z "${FINGERPRINT}" || -z "${PRIVATE_KEY_PATH}" || -z "${REGION}" ]]; then
  echo "[ERROR] Missing required values in ${CONFIG_FILE}"
  exit 1
fi

if [[ ! -f "${PRIVATE_KEY_PATH}" ]]; then
  echo "[ERROR] Private key not found: ${PRIVATE_KEY_PATH}"
  exit 1
fi

echo "[INFO] Discovering availability domain..."
AD_NAME="$(oci iam availability-domain list --compartment-id "${TENANCY_OCID}" --query 'data[0].name' --raw-output)"

if [[ -z "${AD_NAME}" || "${AD_NAME}" == "null" ]]; then
  echo "[ERROR] Could not discover availability domain"
  exit 1
fi

SSH_PUBLIC_KEY_PATH="${HOME}/.ssh/id_ed25519.pub"

if [[ ! -f "${SSH_PUBLIC_KEY_PATH}" ]]; then
  echo "[INFO] SSH public key not found. Generating one..."
  ssh-keygen -t ed25519 -C "danielunesp02@gmail.com" -f "${HOME}/.ssh/id_ed25519" -N ""
fi

SSH_PUBLIC_KEY="$(cat "${SSH_PUBLIC_KEY_PATH}")"

mkdir -p "${TF_DIR}"

cat > "${TFVARS_FILE}" <<EOF2
tenancy_ocid     = "${TENANCY_OCID}"
user_ocid        = "${USER_OCID}"
fingerprint      = "${FINGERPRINT}"
private_key_path = "${PRIVATE_KEY_PATH}"
region           = "${REGION}"

compartment_ocid    = "${TENANCY_OCID}"
availability_domain = "${AD_NAME}"

ssh_public_key = "${SSH_PUBLIC_KEY}"

project_name = "boom"
environment  = "dev"
EOF2

chmod 600 "${TFVARS_FILE}"

echo "[OK] Generated ${TFVARS_FILE}"
echo "region: ${REGION}"
echo "availability_domain: ${AD_NAME}"
echo "private_key_path: ${PRIVATE_KEY_PATH}"
echo
echo "Next:"
echo "  make oracle-doctor"
echo "  make oracle-init"
echo "  make oracle-plan"
