{
  description = "NixOS monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-host-g3.url = "github:barnaby0x0/nixos-host-g3";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nixos-lima = {
      url = "github:nixos-lima/nixos-lima";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:nix-community/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-lima,
      colmena,
      ...
    }:
    let
      lib = import ./lib {
        inherit inputs;
      };

      inherit (lib.commons.system) systems forAllSystems;

    in
    {

      packages = import ./packages { inherit self inputs lib; };

      overlays = import ./overlays { };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./devshells {
          inherit
            inputs
            self
            pkgs
            system
            ;
        }
      );

      # Configurations Home Manager
      homeConfigurations = import ./home {
        inherit inputs lib;
      };

      # Modules Home Manager réutilisables
      # homeModules.default = import ./modules/home-manager;
      homeModules.default = {
        imports = [
          (import ./modules/home-manager)
        ];
        # Vrai car consommé par home-manager dans le client
        # home-manager.lib.homeManagerConfiguration {
        #   inherit pkgs;

        #   modules = [
        #     nix-config.homeModules.default
        #     ./home.nix
        #   ];
        _module.args.mkVim = lib.vim.mkVim;
      };

      nixosConfigurations = {
        gaming = import ./hosts/gaming {
          inherit inputs lib self;
        };

        g3 = inputs.nixos-host-g3.nixosConfigurations.g3;

        lima = import ./hosts/lima {
          inherit inputs lib self;
        };
      }
      // builtins.listToAttrs (
        import ./hosts/installer {
          inherit inputs lib self;
        }
      );

      # apps = forAllSystems (system: {
      #   colmena = {
      #     type = "app";
      #     program = "${colmena.packages.${system}.colmena}/bin/colmena";
      #   };
      # });

      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          syncConfig = pkgs.writeShellApplication {
            name = "sync-config";

            runtimeInputs = [
              pkgs.git
              pkgs.gnutar
              pkgs.gzip
              pkgs.openssh
            ];

            text = ''
              target="''${1:-g3}"

              if [ "$#" -gt 1 ]; then
                echo "Usage: sync-config [target]"
                exit 1
              fi

              repo_root="$(git rev-parse --show-toplevel)"

              echo "Synchronizing $repo_root to $target:/etc/nixos"

              ssh "$target" 'sudo install -d -m 0755 /etc/nixos'

              tar \
                --exclude=.git \
                --exclude=result \
                --exclude=.direnv \
                -C "$repo_root" \
                -czf - . |
                ssh "$target" \
                  'sudo tar --no-same-owner -xzf - -C /etc/nixos'

              echo "Configuration synchronized."
            '';
          };
        in
        {
          sync-config = {
            type = "app";
            program = "${syncConfig}/bin/sync-config";
          };

          colmena = {
            type = "app";
            program = "${colmena.packages.${system}.colmena}/bin/colmena";
          };
        }
      );

      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };

        g3 = {
          imports = inputs.nixos-host-g3.nixosModules.g3;

          deployment = {
            targetHost = "g3";
            targetUser = "colmena";
          };
        };
      };

      # Formatter Nix
      formatter = forAllSystems (system: (lib.homeManager.mkPkgs system).nixfmt);
    };
}
