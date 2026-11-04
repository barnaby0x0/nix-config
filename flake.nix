{
  description = "NixOS monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
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

      lib = lib;

      nixosModules = import ./modules/nixos;

      # nixosModules = {
      #   apps = import ./modules/nixos;
      # };
      # homeModules = import ./modules/home-manager;
      # homeModules = {
      #   default = {
      #     imports = [
      #       (import ./modules/home-manager)
      #     ];
      #     _module.args.mkVim = lib.vim.mkVim;
      #   };

      #   profiles = {
      #     desktop = ./modules/home-manager/profiles/desktop.nix;
      #     development = ./modules/home-manager/profiles/development.nix;
      #   };
      # };

      homeModules = {
        default = {
          imports = [
            ./modules/home-manager
          ];

          _module.args.mkVim = lib.vim.mkVim;
        };

        options = {
          git = ./modules/home-manager/options/opt-git.nix;
        };

        programs = {
          common = ./modules/home-manager/programs/common.nix;
          git = ./modules/home-manager/programs/git.nix;
          shell = ./modules/home-manager/programs/shell.nix;
          vim = ./modules/home-manager/programs/vim.nix;
          terminator = ./modules/home-manager/programs/terminator.nix;
          tmux = ./modules/home-manager/programs/tmux.nix;
          brave = ./modules/home-manager/programs/brave.nix;
        };

        profiles = {
          desktop = ./modules/home-manager/profiles/desktop.nix;
          development = ./modules/home-manager/profiles/development.nix;
        };
      };

      nixosConfigurations = {
        gaming = import ./hosts/gaming {
          inherit inputs lib self;
        };

        g3 = import ./hosts/g3 {
          inherit inputs lib self;
        };

        lima = import ./hosts/lima {
          inherit inputs lib self;
        };
      }
      // builtins.listToAttrs (
        import ./hosts/installer {
          inherit inputs lib self;
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};

          provisionG3 = pkgs.writeShellApplication {
            name = "provision-g3";

            runtimeInputs = [
              inputs.nixos-anywhere.packages.${system}.default
            ];

            text = ''
              target_host="''${TARGET_HOST:-nixos@10.10.0.57}"

              echo "WARNING: DESTRUCTIVE OPERATION"
              echo "Target: $target_host"
              echo "Configuration: g3"
              echo
              echo "This operation may destroy existing data."
              echo

              read -r -p "Type 'PROVISION-G3' to continue: " confirmation

              if [[ "$confirmation" != "PROVISION-G3" ]]; then
                echo "Aborted."
                exit 1
              fi

              exec nixos-anywhere \
                --flake .#g3 \
                --target-host "$target_host" \
                --build-on local \
                "$@"
            '';
          };
        in
        {
          colmena = {
            type = "app";
            program = "${inputs.colmena.packages.${system}.colmena}/bin/colmena";
          };

          install-g3 = {
            type = "app";
            program = "${provisionG3}/bin/provision-g3";
          };
        }
      );

      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
          nodeSpecialArgs.g3 = self.nixosConfigurations.g3._module.specialArgs;
          nodeSpecialArgs.k8 = self.nixosConfigurations.gaming._module.specialArgs;
        };

        g3 = {
          imports = self.nixosConfigurations.g3._module.args.modules;
          deployment = {
            targetHost = "g3";
            targetUser = "colmena";
          };
        };

        k8 = {
          imports = self.nixosConfigurations.gaming._module.args.modules;
          deployment = {
            targetHost = "k8";
            targetUser = "colmena";
          };
        };
      };

      # Formatter Nix
      formatter = forAllSystems (system: (lib.homeManager.mkPkgs system).nixfmt);
    };
}
