#!/usr/bin/env bash
set -euo pipefail

echo "Checking OCI CLI..."
oci --version

echo "Checking OCI session..."
oci iam region list --output table
