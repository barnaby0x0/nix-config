#!/usr/bin/env bash
set -Eeuo pipefail

# Configuration
BRANCH="main"
FLAKE="github:barnaby0x0/nix-config?ref=${BRANCH}"
HOST="g3"
DISK="/dev/nvme0n1"

# Activer les fonctionnalités nécessaires
export NIX_CONFIG="experimental-features = nix-command flakes"

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

die() {
  printf 'ERREUR : %s\n' "$*" >&2
  exit 1
}

# Vérifications initiales
[[ $EUID -eq 0 ]] || die "Lancer ce script en root."
[[ -b "$DISK" ]] || die "Disque introuvable : $DISK"
command -v nix >/dev/null || die "nix est introuvable."
command -v ssh-keygen >/dev/null || die "ssh-keygen est introuvable."
command -v nixos-install >/dev/null || die "nixos-install est introuvable."

log "Disque cible : $DISK"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS "$DISK"

read -r -p "Pour effacer $DISK et installer $HOST, tape exactement ERASE-$HOST : " CONFIRM
[[ "$CONFIRM" == "ERASE-$HOST" ]] || die "Installation annulée."

# Vérifier le flake distant
log "Vérification du flake distant"
nix flake show "$FLAKE"

# Vérifier que le host existe dans le flake
log "Évaluation de la configuration NixOS"
nix eval --raw "$FLAKE#nixosConfigurations.$HOST.config.system.build.toplevel.drvPath"

# Partitionnement avec Disko
log "Partitionnement de $DISK avec la configuration Disko de $HOST"
nix run github:nix-community/disko -- \
  --mode destroy,format,mount \
  --flake "$FLAKE#$HOST"

# Installation NixOS
log "Installation de NixOS : $HOST"
nixos-install --flake "$FLAKE#$HOST" --no-root-passwd

log "Installation terminée. Tu peux redémarrer."