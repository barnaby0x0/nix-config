#!/usr/bin/env bash
set -euo pipefail

nix eval --impure --json -f tests/virt-module.nix

echo "Tests du module virt.nix réussis."
