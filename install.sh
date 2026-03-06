#!/usr/bin/env bash
# Installer for dot-droid configuration.
#
# Two modes:
#   ./install.sh --global           # Symlink global/ contents to ~/.factory/
#   ./install.sh /path/to/project   # Copy project template into target
#
# Global install creates symlinks so updates to dot-droid propagate
# automatically. Project install copies templates (no symlinks).

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GLOBAL_SOURCE="${SCRIPT_DIR}/global"
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
  echo "Usage: $0 --global              # Install global config to ~/.factory/"
  echo "       $0 /path/to/project      # Install project template"
  echo "       $0 -h | --help"
  echo ""
  echo "Global install: symlinks droids/, commands/, skills/ to ~/.factory/"
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

  mkdir -p "${FACTORY_HOME}"
  mkdir -p "${FACTORY_HOME}/logs"

  echo "Linking configuration:"

  # Settings and MCP — copy rather than symlink so user can customize
  copy_if_missing "${GLOBAL_SOURCE}/settings.json" "${FACTORY_HOME}/settings.json"
  copy_if_missing "${GLOBAL_SOURCE}/mcp.json" "${FACTORY_HOME}/mcp.json"

  # Directories — symlink for auto-propagation
  link_directory "${GLOBAL_SOURCE}/droids" "${FACTORY_HOME}/droids"
  link_directory "${GLOBAL_SOURCE}/commands" "${FACTORY_HOME}/commands"
  link_directory "${GLOBAL_SOURCE}/skills" "${FACTORY_HOME}/skills"

  echo ""
  echo "Global installation complete."
  echo ""
  echo "Linked components:"
  echo "  ~/.factory/settings.json  <- copied (customize freely)"
  echo "  ~/.factory/mcp.json       <- copied (customize freely)"
  echo "  ~/.factory/droids/        -> dot-droid/global/droids/"
  echo "  ~/.factory/commands/      -> dot-droid/global/commands/"
  echo "  ~/.factory/skills/        -> dot-droid/global/skills/"
  echo ""
  echo "To override any component, replace the symlink with a real"
  echo "file or directory."
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

echo ""
echo "Project installation complete."
echo ""
echo "Installed components:"
echo "  .droid.yaml               — PR review configuration"
echo "  .factory/droids/          — Project-local droid overrides (empty)"
echo ""
echo "Add project-specific droids to .factory/droids/ to override"
echo "or extend the global configuration."
