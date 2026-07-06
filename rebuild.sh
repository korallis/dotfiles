#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles

# Heal a half-torn-down Homebrew prefix. nix-homebrew only recreates the prefix
# skeleton when /opt/homebrew/.managed_by_nix_darwin is absent, so if Library/ has
# been wiped (interrupted rebuild, manual `brew` uninstall) while the marker
# survives, activation dies on:
#   ln: /opt/homebrew/Library/Homebrew: No such file or directory
# Dropping the stale marker lets nix-homebrew reinitialize and reinstall casks.
if [[ -e /opt/homebrew/.managed_by_nix_darwin && ! -d /opt/homebrew/Library ]]; then
  echo "rebuild: repairing half-initialized Homebrew prefix (removing stale marker)" >&2
  sudo rm -f /opt/homebrew/.managed_by_nix_darwin
fi

exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
