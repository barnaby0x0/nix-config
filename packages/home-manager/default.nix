{
  self,
  inputs,
  lib,
}:

let
  inherit (inputs) home-manager;
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) systems forAllSystems;
in
forAllSystems (
  system:
  let
    pkgs = mkPkgs system;

    homeManagerPackage = home-manager.packages.${system}.default;

    install =
      configuration:
      pkgs.writeShellApplication {
        name = "nixdot-install";

        runtimeInputs = [
          pkgs.nix
          homeManagerPackage
        ];

        text =
          if configuration != null then
            ''
              exec home-manager switch \
                --flake "${self}#${configuration}" \
                "$@"
            ''
          else
            ''
              if [ "$#" -lt 1 ]; then
                echo "Usage: nix run .#install -- <configuration> [options]" >&2
                exit 1
              fi

              configuration="$1"
              shift

              exec home-manager switch \
                --flake "${self}#$configuration" \
                "$@"
            '';
      };
  in
  {
    nixdot = pkgs.writeShellApplication {
      name = "nixdot";

      runtimeInputs = [
        pkgs.nix
        pkgs.coreutils
        homeManagerPackage
      ];

      text = ''
        config=""
        hm_args=()

        while [ $# -gt 0 ]; do
          case "$1" in
            --config)
              [ $# -ge 2 ] || {
                echo "Erreur : --config nécessite un fichier." >&2
                exit 1
              }
              config="$2"
              shift 2
              ;;
            -h|--help)
              echo "Usage : nixdot --config <fichier.nix> [options home-manager, ex: -b backup]"
              exit 0
              ;;
            *)
              hm_args+=("$1")
              shift
              ;;
          esac
        done

        [ -n "$config" ] && [ -f "$config" ] || {
          echo "Erreur : fichier de configuration absent ou introuvable." >&2
          exit 1
        }

        NIXDOT_CONFIG="$(realpath "$config")"
        export NIXDOT_CONFIG

        exec home-manager switch --impure \
          --flake "${self}#generic-${system}" \
          "''${hm_args[@]}"
      '';
    };

    install-victor-laptop = install "victor-laptop";
    install-victor-macbook = install "victor-macbook";
    install = install null;
  }
)
