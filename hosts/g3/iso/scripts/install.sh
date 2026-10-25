
#!/usr/bin/env bash
set -Eeuo pipefail

# Configuration
FLAKE="github:barnaby0x0/nix-config"
HOST="g3"
DISK="/dev/nvme0n1"
PERSIST="/mnt/nix/persist"

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

# Préparer les répertoires persistants
log "Préparation des répertoires persistants"

mkdir -p \
  "$PERSIST/var/lib/nixos" \
  "$PERSIST/var/log" \
  "$PERSIST/etc/ssh" \
  "$PERSIST/home/user/documents"

chmod 700 "$PERSIST/etc/ssh"

# Générer la clé SSH d'hôte
HOST_KEY="$PERSIST/etc/ssh/ssh_host_ed25519_key"

if [[ ! -f "$HOST_KEY" ]]; then
  log "Génération de la clé SSH d'hôte Ed25519"

  ssh-keygen \
    -q \
    -t ed25519 \
    -N "" \
    -C "$HOST-host" \
    -f "$HOST_KEY"
else
  log "La clé SSH d'hôte existe déjà ; conservation."
fi

chmod 600 "$HOST_KEY"
chmod 644 "$HOST_KEY.pub"

log "Empreinte de la clé SSH d'hôte"
ssh-keygen -lf "$HOST_KEY.pub"

# Initialiser l'identité persistante
if [[ ! -s "$PERSIST/etc/machine-id" ]]; then
  log "Initialisation du machine-id"
  systemd-machine-id-setup --root="$PERSIST"
fi

# Propriétaire des documents
chown -R 1000:100 "$PERSIST/home/user/documents"

# Installation NixOS
log "Installation de NixOS : $HOST"
nixos-install --flake "$FLAKE#$HOST" --no-root-passwd

log "Installation terminée. Tu peux redémarrer."
