#!/usr/bin/env bash
# Installer for dot-droid configuration.
#
# Two modes:
#   ./install.sh --global           # Symlink ~/.factory -> dot-droid/.factory/
#   ./install.sh /path/to/project   # Copy project template into target
#
# Global install creates a single symlink so all changes to the repo
# propagate to ~/.factory/ automatically. Project install copies templates.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GLOBAL_SOURCE="${SCRIPT_DIR}/.factory"
PROJECT_SOURCE="${SCRIPT_DIR}/project"
FACTORY_HOME="${HOME}/.factory"

# --- Helper functions ---

link_file() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]]; then
    local existing_target
    existing_target=$(readlink "$dst")
    if [[ "$existing_target" == "$src" ]]; then
      echo "  [skip] $(basename "$dst") — already linked"
      return 0
    fi
    echo "  [update] $(basename "$dst") — updating symlink"
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    echo "  [skip] $(basename "$dst") — real file exists (user override)"
    return 0
  else
    echo "  [link] $(basename "$dst")"
  fi

  ln -s "$src" "$dst"
}

link_directory() {
  local src="$1"
  local dst="$2"
  local name
  name=$(basename "$dst")

  if [[ -L "$dst" ]]; then
    local existing_target
    existing_target=$(readlink "$dst")
    if [[ "$existing_target" == "$src" ]]; then
      echo "  [skip] ${name}/ — already linked"
      return 0
    fi
    echo "  [update] ${name}/ — updating symlink"
    rm "$dst"
  elif [[ -d "$dst" ]]; then
    echo "  [skip] ${name}/ — real directory exists (user override)"
    return 0
  else
    echo "  [link] ${name}/"
  fi

  ln -s "$src" "$dst"
}

copy_if_missing() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" ]]; then
    echo "  [skip] $(basename "$dst") — already exists"
  else
    echo "  [copy] $(basename "$dst")"
    cp "$src" "$dst"
  fi
}

# --- Usage ---

usage() {
  echo "Usage: $0 --global              # Symlink ~/.factory -> dot-droid/.factory/"
  echo "       $0 /path/to/project      # Install project template"
  echo "       $0 -h | --help"
  echo ""
  echo "Global install: single symlink ~/.factory -> $(basename "${SCRIPT_DIR}")/.factory/"
  echo "Project install: copies .droid.yaml and .factory/ template to target"
}

if [[ $# -lt 1 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  usage
  exit 0
fi

# --- Global install ---

if [[ "$1" == "--global" ]]; then
  echo "Installing dot-droid global configuration"
  echo "  Source: ${GLOBAL_SOURCE}"
  echo "  Target: ${FACTORY_HOME}"
  echo ""

  echo "Linking configuration:"

  # Single symlink: ~/.factory -> dot-droid/.factory/
  if [[ -L "${FACTORY_HOME}" ]]; then
    existing_target=$(readlink "${FACTORY_HOME}")
    if [[ "$existing_target" == "${GLOBAL_SOURCE}" ]]; then
      echo "  [skip] ~/.factory — already linked"
    else
      echo "  [update] ~/.factory — updating symlink"
      rm "${FACTORY_HOME}"
      ln -s "${GLOBAL_SOURCE}" "${FACTORY_HOME}"
    fi
  elif [[ -d "${FACTORY_HOME}" ]]; then
    echo "  [skip] ~/.factory — real directory exists (will not overwrite)"
    echo "         Move or remove ~/.factory to switch to symlink install."
    exit 1
  else
    echo "  [link] ~/.factory -> ${GLOBAL_SOURCE}"
    ln -s "${GLOBAL_SOURCE}" "${FACTORY_HOME}"
  fi

  mkdir -p "${FACTORY_HOME}/logs"

  # Settings and MCP — copy from .example if not already present
  # Files live in the repo dir (.factory/) but are gitignored — machine-local
  copy_if_missing "${GLOBAL_SOURCE}/settings.json.example" "${FACTORY_HOME}/settings.json"
  copy_if_missing "${GLOBAL_SOURCE}/mcp.json.example" "${FACTORY_HOME}/mcp.json"

  echo ""
  echo "Global installation complete."
  echo ""
  echo "Linked:"
  echo "  ~/.factory -> ${GLOBAL_SOURCE}"
  echo ""
  echo "Machine-local (gitignored, edit freely):"
  echo "  ~/.factory/settings.json   — model, autonomy, allowlists"
  echo "  ~/.factory/mcp.json        — MCP server integrations"
  echo ""
  echo "All droids, commands, and skills are live immediately via the symlink."
  exit 0
fi

# --- Project install ---

TARGET_DIR="$(cd "$1" && pwd)"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Target directory does not exist: $1" >&2
  exit 1
fi

if [[ "$TARGET_DIR" == "$SCRIPT_DIR" ]]; then
  echo "Error: Cannot install into the dot-droid repository itself" >&2
  exit 1
fi

echo "Installing dot-droid project template"
echo "  Source: ${PROJECT_SOURCE}"
echo "  Target: ${TARGET_DIR}"
echo ""

echo "Copying project files:"

# .droid.yaml
copy_if_missing "${PROJECT_SOURCE}/.droid.yaml" "${TARGET_DIR}/.droid.yaml"

# .factory/ directory
mkdir -p "${TARGET_DIR}/.factory/droids"
if [[ ! -e "${TARGET_DIR}/.factory/droids/.gitkeep" ]]; then
  touch "${TARGET_DIR}/.factory/droids/.gitkeep"
  echo "  [create] .factory/droids/.gitkeep"
fi

mkdir -p "${TARGET_DIR}/.factory/logs"
if [[ ! -e "${TARGET_DIR}/.factory/logs/.gitignore" ]]; then
  printf '*\n!.gitignore\n' > "${TARGET_DIR}/.factory/logs/.gitignore"
  echo "  [create] .factory/logs/.gitignore"
fi

echo ""
echo "Project installation complete."
echo ""
echo "Installed components:"
echo "  .droid.yaml               — PR review configuration"
echo "  .factory/droids/          — Project-local droid overrides (empty)"
echo "  .factory/logs/            — Session logs (gitignored)"
echo ""
echo "Add project-specific droids to .factory/droids/ to override"
echo "or extend the global configuration."
