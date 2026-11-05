{ pkgs, lib }:
let
  runtimePackages = with pkgs; [
    podman
    podman-compose

    # OCI runtime
    crun
    conmon

    # Networking
    passt
    netavark
    aardvark-dns

    # Storage
    fuse-overlayfs

    # Image utilities
    skopeo
    dive
  ];
in
lib.mkDevShell {
  name = "podman";

  packages = runtimePackages;

  shellHook = ''
    export PODMAN_PROJECT_DIR="$PWD/.podman"
    export XDG_DATA_HOME="$PODMAN_PROJECT_DIR/data"
    export XDG_CONFIG_HOME="$PODMAN_PROJECT_DIR/config"   # ← isole aussi la config

    mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME/containers"

    # Symlinks vers les fichiers du store Nix (reproductibles)
    ln -sf ${./containers/policy.json}      "$XDG_CONFIG_HOME/containers/policy.json"
    ln -sf ${./containers/registries.conf}  "$XDG_CONFIG_HOME/containers/registries.conf"

    echo ""
    echo "=================================="
    echo "       Podman Nix Environment"
    echo "=================================="
    echo ""
    echo "Podman:   $(podman --version)"
    echo "Storage:  $XDG_DATA_HOME"
    echo "Config:   $XDG_CONFIG_HOME"
    echo ""
    echo "Commands:"
    echo "  podman info"
    echo "  podman run --rm -it alpine sh"
    echo "  podman compose up -d"
    echo ""
  '';
}
