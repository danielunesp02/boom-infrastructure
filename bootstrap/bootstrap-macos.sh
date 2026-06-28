#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo " Boom macOS Bootstrap"
echo "======================================"

# Xcode CLT
if ! xcode-select -p >/dev/null 2>&1; then
  echo "[INFO] Installing Xcode Command Line Tools..."
  xcode-select --install || true
  echo
  echo "Complete the installation dialog, then re-run this script."
  exit 0
else
  echo "[OK] Xcode Command Line Tools"
fi

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "[INFO] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || true)"
eval "$(/usr/local/bin/brew shellenv 2>/dev/null || true)"

brew update

FORMULAE=(
git
gh
openjdk@21
maven
terraform
jq
yq
wget
tree
htop
make
docker
colima
kubectl
helm
)

for pkg in "${FORMULAE[@]}"; do
  if brew list "$pkg" >/dev/null 2>&1; then
    echo "[OK] $pkg"
  else
    echo "[INSTALL] $pkg"
    brew install "$pkg"
  fi
done

if ! brew list --cask intellij-idea-ce >/dev/null 2>&1; then
  brew install --cask intellij-idea-ce
fi

if ! brew list --cask visual-studio-code >/dev/null 2>&1; then
  brew install --cask visual-studio-code
fi

echo
echo "Java:"
java -version || true

echo
echo "Terraform:"
terraform version || true

echo
echo "GitHub CLI:"
gh --version || true

echo
echo "Docker:"
docker --version || true

echo
echo "======================================"
echo "Next steps"
echo "======================================"
echo "1. gh auth login"
echo "2. ssh-keygen -t ed25519 (if needed)"
echo "3. Start Docker Desktop OR: colima start"
echo "4. Install OCI CLI"
echo "5. Configure Oracle credentials"
