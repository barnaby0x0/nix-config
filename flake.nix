{
  description = "NixOS monorepo";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-26.05";
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

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

      # mkPkgs =
      #   system:
      #   import inputs.nixpkgs {
      #     inherit system;

      #     config.allowUnfreePredicate =
      #       pkg:
      #       builtins.elem (inputs.nixpkgs.lib.getName pkg) [
      #         "vim-yaml"
      #       ];
      #   };

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
        inherit self inputs lib;
      };

      lib = lib;

      buildModules = import ./modules/builders;

      nixosModules = import ./modules/nixos;

      homeModules = import ./modules/home-manager;

      nixosConfigurations = {
        k8 = import ./hosts/k8 {
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

          mkProvision =
            {
              name,
              host,
              targetHost,
              description ? "Provision ${host} NixOS host",
            }:
            let
              provision = pkgs.writeShellApplication {
                name = name;

                runtimeInputs = [
                  inputs.nixos-anywhere.packages.${system}.default
                ];

                text = ''
                  target_host="''${TARGET_HOST:-${targetHost}}"

                  echo "WARNING: DESTRUCTIVE OPERATION"
                  echo "Target: $target_host"
                  echo "Configuration: ${host}"
                  echo
                  echo "This operation may destroy existing data."
                  echo

                  read -r -p "Type '${host}' to continue: " confirmation

                  if [[ "$confirmation" != "${host}" ]]; then
                    echo "Aborted."
                    exit 1
                  fi

                  exec nixos-anywhere \
                    --flake ".#${host}" \
                    --target-host "$target_host" \
                    --build-on local \
                    "$@"
                '';
              };
            in
            {
              type = "app";
              program = "${provision}/bin/${name}";
              meta.description = description;
            };

          mkInstallHome =
            {
              name,
              targetHost,
              homeConfiguration,
            }:

            let
              app = pkgs.writeShellApplication {
                inherit name;

                runtimeInputs = [
                  pkgs.openssh
                  inputs.home-manager.packages.${system}.default
                ];

                text = ''
                  target_host="''${TARGET_HOST:-${targetHost}}"

                  echo "Deploying Home Manager configuration to $target_host"

                  exec ssh "$target_host" \
                    'nix run home-manager -- switch --flake "github:barnaby0x0/nix-config/develop#${homeConfiguration}" --refresh' \
                    "$@"
                '';
              };
            in
            {
              type = "app";
              program = "${app}/bin/${name}";
              meta.description = "Deploy Home Manager configuration ${homeConfiguration}";
            };

        in
        {
          colmena = {
            type = "app";
            program = "${inputs.colmena.packages.${system}.colmena}/bin/colmena";
            meta.description = "Colmena deployment tool";
          };

          install-g3 = mkProvision {
            name = "install-g3";
            host = "g3";
            targetHost = "nixos@10.10.0.57";
          };

          install-k8 = mkProvision {
            name = "install-k8";
            host = "k8";
            targetHost = "nixos@10.10.0.12";
          };

          install-home-k8 = mkInstallHome {
            name = "install-home-k8";
            targetHost = "user@10.10.0.12";
            homeConfiguration = "user@k8";
          };

          install-home-g3 = mkInstallHome {
            name = "install-home-g3";
            targetHost = "user@10.10.0.57";
            homeConfiguration = "user@g3";
          };
        }
      );

      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
          nodeSpecialArgs.g3 = self.nixosConfigurations.g3._module.specialArgs;
          nodeSpecialArgs.k8 = self.nixosConfigurations.k8._module.specialArgs;
        };

        g3 = {
          imports = self.nixosConfigurations.g3._module.args.modules;
          deployment = {
            targetHost = "g3";
            targetUser = "colmena";
          };
        };

        k8 = {
          imports = self.nixosConfigurations.k8._module.args.modules;
          deployment = {
            targetHost = "k8";
            targetUser = "colmena";
          };
        };
      };

      # Formatter Nix
      formatter = forAllSystems (system: (lib.commons.mkPkgs system).nixfmt);
    };
}
