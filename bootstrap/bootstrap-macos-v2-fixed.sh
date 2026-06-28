#!/usr/bin/env bash
set -euo pipefail

BOOTSTRAP_VERSION="0.2.1"
PROJECT_NAME="Boom"
REPORT_DIR=".boom"
REPORT_MD="${REPORT_DIR}/developer-env.md"
REPORT_JSON="${REPORT_DIR}/developer-env.json"

mkdir -p "${REPORT_DIR}"

log() { echo "[$(date '+%H:%M:%S')] $*"; }
ok() { echo "✅ $*"; }
warn() { echo "⚠️  $*"; }
fail() { echo "❌ $*"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

section() {
  echo
  echo "======================================"
  echo "$1"
  echo "======================================"
}

detect_shell_profile() {
  case "${SHELL:-}" in
    */zsh) echo "$HOME/.zshrc" ;;
    */bash) echo "$HOME/.bash_profile" ;;
    *) echo "$HOME/.profile" ;;
  esac
}

ensure_line_in_file() {
  local line="$1"
  local file="$2"

  touch "$file"
  if ! grep -Fq "$line" "$file"; then
    echo "$line" >> "$file"
  fi
}

install_formula() {
  local pkg="$1"

  if brew list "$pkg" >/dev/null 2>&1; then
    ok "$pkg already installed"
  else
    log "Installing $pkg"
    brew install "$pkg"
  fi
}

install_cask() {
  local pkg="$1"

  if brew list --cask "$pkg" >/dev/null 2>&1; then
    ok "$pkg already installed"
  else
    log "Installing cask $pkg"
    brew install --cask "$pkg"
  fi
}

version_or_missing() {
  local cmd="$1"
  local args="${2:---version}"

  if command_exists "$cmd"; then
    $cmd $args 2>&1 | head -n 1 | sed 's/"/\\"/g'
  else
    echo "missing"
  fi
}

section "Boom Bootstrap v${BOOTSTRAP_VERSION}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  fail "This script currently supports macOS only."
  exit 1
fi

ARCH="$(uname -m)"
PROFILE_FILE="$(detect_shell_profile)"

log "Architecture: ${ARCH}"
log "Shell profile: ${PROFILE_FILE}"

section "Xcode Command Line Tools"

if xcode-select -p >/dev/null 2>&1; then
  ok "Xcode Command Line Tools installed: $(xcode-select -p)"
else
  warn "Xcode Command Line Tools not installed."
  xcode-select --install || true
  echo "Complete the macOS installation dialog and rerun this script."
  exit 0
fi

section "Homebrew"

if ! command_exists brew; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ensure_line_in_file 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$PROFILE_FILE"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
  ensure_line_in_file 'eval "$(/usr/local/bin/brew shellenv)"' "$PROFILE_FILE"
fi

ok "Homebrew: $(brew --version | head -n 1)"
brew update

section "Core Developer Tools"

# Do not install openjdk@21 as a formula on macOS here.
# Homebrew may try to build it from source and require full Xcode.
# We install Java 21 using the Temurin cask instead.
FORMULAE=(
  git
  gh
  maven
  terraform
  jq
  yq
  wget
  tree
  htop
  make
  colima
  docker
  docker-compose
  kubectl
  helm
  pre-commit
)

for pkg in "${FORMULAE[@]}"; do
  install_formula "$pkg"
done

section "Applications and Java"

install_cask "temurin@21"
install_cask "intellij-idea-ce"
install_cask "visual-studio-code"

section "Java 21 Configuration"

JAVA_21_HOME=""
if /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
  JAVA_21_HOME="$(/usr/libexec/java_home -v 21)"
fi

if [[ -n "${JAVA_21_HOME}" ]]; then
  ensure_line_in_file 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' "$PROFILE_FILE"
  ensure_line_in_file 'export PATH="$JAVA_HOME/bin:$PATH"' "$PROFILE_FILE"
  export JAVA_HOME="${JAVA_21_HOME}"
  export PATH="$JAVA_HOME/bin:$PATH"
  ok "JAVA_HOME configured: ${JAVA_HOME}"
else
  warn "Java 21 was not detected after installing Temurin."
  echo "Try opening a new terminal or run:"
  echo "  source ${PROFILE_FILE}"
fi

section "Docker Runtime"

if ! docker info >/dev/null 2>&1; then
  warn "Docker daemon is not running."

  if command_exists colima; then
    log "Starting Colima with 4 CPUs and 6GB memory"
    colima start --cpu 4 --memory 6 || true
  fi
else
  ok "Docker daemon is running"
fi

if docker info >/dev/null 2>&1; then
  ok "Docker ready"
else
  warn "Docker still not available. Open Docker Desktop or run: colima start"
fi

section "Git Configuration"

CURRENT_GIT_NAME="$(git config --global user.name || true)"
CURRENT_GIT_EMAIL="$(git config --global user.email || true)"

if [[ -z "${CURRENT_GIT_NAME}" ]]; then
  git config --global user.name "Daniel Bevilacqua"
  ok "Configured git user.name"
else
  ok "git user.name: ${CURRENT_GIT_NAME}"
fi

if [[ -z "${CURRENT_GIT_EMAIL}" ]]; then
  git config --global user.email "danielunesp02@gmail.com"
  ok "Configured git user.email"
else
  ok "git user.email: ${CURRENT_GIT_EMAIL}"
fi

git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global fetch.prune true

ok "Git defaults configured"

section "GitHub CLI"

if command_exists gh; then
  if gh auth status >/dev/null 2>&1; then
    ok "GitHub CLI authenticated"
  else
    warn "GitHub CLI is installed but not authenticated."
    echo "Run: gh auth login"
  fi
else
  warn "GitHub CLI missing"
fi

section "SSH"

if [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
  ok "SSH public key found: ~/.ssh/id_ed25519.pub"
else
  warn "No ~/.ssh/id_ed25519.pub found."
  echo "Generate one with:"
  echo "ssh-keygen -t ed25519 -C \"danielunesp02@gmail.com\""
fi

section "OCI CLI"

if command_exists oci; then
  ok "OCI CLI installed: $(oci --version 2>&1 | head -n 1)"
else
  warn "OCI CLI not installed."
  echo "Install later with:"
  echo 'bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"'
fi

section "Repository Checks"

REPOS=(
  boom-platform
  boom-backend
  boom-frontend
  boom-infrastructure
)

CURRENT_DIR="$(pwd)"
for repo in "${REPOS[@]}"; do
  if [[ -d "../${repo}/.git" || "$(basename "$CURRENT_DIR")" == "${repo}" ]]; then
    ok "Repository visible: ${repo}"
  else
    warn "Repository not found near current path: ${repo}"
  fi
done

section "Tool Versions"

GIT_VERSION="$(version_or_missing git --version)"
GH_VERSION="$(version_or_missing gh --version)"
JAVA_VERSION="$(java -version 2>&1 | head -n 1 | sed 's/"/\\"/g' || echo missing)"
MAVEN_VERSION="$(version_or_missing mvn --version)"
TERRAFORM_VERSION="$(version_or_missing terraform version)"
DOCKER_VERSION="$(version_or_missing docker --version)"
COLIMA_VERSION="$(version_or_missing colima version)"
KUBECTL_VERSION="$(kubectl version --client 2>/dev/null | head -n 1 | sed 's/"/\\"/g' || echo missing)"
HELM_VERSION="$(version_or_missing helm version)"

cat <<EOF > "${REPORT_MD}"
# Boom Developer Environment

Generated at: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

## Bootstrap

- Version: ${BOOTSTRAP_VERSION}
- OS: macOS
- Architecture: ${ARCH}
- Shell profile: ${PROFILE_FILE}

## Tools

- Git: ${GIT_VERSION}
- GitHub CLI: ${GH_VERSION}
- Java: ${JAVA_VERSION}
- Maven: ${MAVEN_VERSION}
- Terraform: ${TERRAFORM_VERSION}
- Docker: ${DOCKER_VERSION}
- Colima: ${COLIMA_VERSION}
- kubectl: ${KUBECTL_VERSION}
- Helm: ${HELM_VERSION}

## Next Steps

1. Run \`gh auth login\` if GitHub CLI is not authenticated.
2. Add SSH key to GitHub if needed.
3. Install and configure OCI CLI.
4. Create \`terraform/environments/dev/terraform.tfvars\`.
5. Run \`make local-up\`.
6. Run \`make tf-init && make tf-validate\`.
EOF

cat <<EOF > "${REPORT_JSON}"
{
  "project": "${PROJECT_NAME}",
  "bootstrapVersion": "${BOOTSTRAP_VERSION}",
  "generatedAt": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "os": "macOS",
  "architecture": "${ARCH}",
  "tools": {
    "git": "${GIT_VERSION}",
    "githubCli": "${GH_VERSION}",
    "java": "${JAVA_VERSION}",
    "maven": "${MAVEN_VERSION}",
    "terraform": "${TERRAFORM_VERSION}",
    "docker": "${DOCKER_VERSION}",
    "colima": "${COLIMA_VERSION}",
    "kubectl": "${KUBECTL_VERSION}",
    "helm": "${HELM_VERSION}"
  }
}
EOF

section "Report"

ok "Markdown report: ${REPORT_MD}"
ok "JSON report: ${REPORT_JSON}"

section "Completed"

echo "Boom macOS bootstrap v${BOOTSTRAP_VERSION} completed."
echo
echo "Recommended next commands:"
echo "  source ${PROFILE_FILE}"
echo "  make check-tools"
echo "  make local-up"
echo "  make tf-init"
echo "  make tf-validate"
