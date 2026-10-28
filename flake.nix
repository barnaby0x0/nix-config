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

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-lima,
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
      
      overlays.default = import ./overlays;

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

      # Formatter Nix
      formatter = forAllSystems (system: (lib.homeManager.mkPkgs system).nixfmt);
    };
}
