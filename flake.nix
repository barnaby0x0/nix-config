{
  description = "NixOS monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      lib = import ./lib {
        inherit inputs;
      };

      inherit (lib.commons.system) systems forAllSystems;

    in
    {

      packages = forAllSystems (
        system:
        (import ./packages {
          inherit self inputs lib;
        }).${system}
        // {
          vim = lib.vim.mkVim { inherit system; };
        }
      );

      # # Packages : nixdot, install, etc.
      # packages = import ./packages {
      #   inherit self inputs lib;
      # };

      # Environnements de développement
      devShells = import ./devshells {
        inherit self inputs lib;
      };

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

      # Formatter Nix
      formatter = forAllSystems (system: (lib.homeManager.mkPkgs system).nixfmt);
    };
}
