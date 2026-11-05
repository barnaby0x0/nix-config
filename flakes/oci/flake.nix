
{
  description = "Standalone rootless Podman development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:

    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

    in
    {
      packages = forAllSystems (system:

        let
          pkgs = import nixpkgs {
            inherit system;
          };

        in
        {
          hello-image = pkgs.dockerTools.buildImage {
            name = "nix-hello";
            tag = "latest";

            copyToRoot = pkgs.buildEnv {
              name = "hello-root";
              paths = [ pkgs.hello ];
              pathsToLink = [ "/bin" ];
            };

            config = {
              Cmd = [ "/bin/hello" ];
            };
          };

          default = pkgs.podman;
        }
      );

      devShells = forAllSystems (system:

        let
          pkgs = import nixpkgs {
            inherit system;
          };

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
        {
          default = pkgs.mkShell {
            packages = runtimePackages;

            shellHook = ''
              export PODMAN_PROJECT_DIR="$PWD/.podman"

              # Isolated persistent storage
              export XDG_DATA_HOME="$PODMAN_PROJECT_DIR/data"

              mkdir -p "$XDG_DATA_HOME"

              echo ""
              echo "=================================="
              echo "       Podman Nix Environment"
              echo "=================================="
              echo ""
              echo "Podman: $(podman --version)"
              echo "Storage: $XDG_DATA_HOME"
              echo ""
              echo "Commands:"
              echo "  podman info"
              echo "  podman run --rm -it alpine sh"
              echo "  podman compose up -d"
              echo ""
            '';
          };
        }
      );

      formatter = forAllSystems (system:
        (import nixpkgs {
          inherit system;
        }).nixfmt-rfc-style
      );
    };
}
