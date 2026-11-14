#!/usr/bin/env bash
# test-eval.sh : évalue de bout en bout les sorties principales du flake (sans build).
# Usage : ./test-eval.sh   (code de sortie 1 si au moins une évaluation échoue)
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

targets=(
  '.#packages.x86_64-linux.vim.drvPath'
  '.#nixosConfigurations.g3.config.system.build.toplevel.drvPath'
  '.#nixosConfigurations.k8.config.system.build.toplevel.drvPath'
  '.#homeConfigurations."user@k8".activationPackage.drvPath'
  '.#packages.x86_64-linux.brave.drvPath'
)

fail=0
for t in "${targets[@]}"; do
  if out=$(nix eval --raw --option warn-dirty false "$t" 2>&1); then
    echo "PASS $t"
  else
    echo "FAIL $t"
    echo "$out" | tail -n 8 | sed 's/^/     /'
    fail=1
  fi
done
exit "$fail"
