{
  description = "NixOS monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vim-flake = {
      url = "github:Victor733909/flakes?dir=vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      vim-flake,
      ...
    }:
    let
      lib = import ./lib {
        inherit inputs;
      };

      inherit (lib.commons.system) systems forAllSystems;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Packages : nixdot, install, etc.
      packages = import ./packages {
        inherit self inputs lib;
      };

      # Environnements de développement
      devShells = import ./devshells {
        inherit self inputs lib;
      };

      # Configurations Home Manager
      homeConfigurations = import ./home {
        inherit inputs lib;
      };

      # Modules Home Manager réutilisables
      homeModules.default = import ./modules/home-manager;

      # Formatter Nix
      formatter = forAllSystems (system: (lib.homeManager.mkPkgs system).nixfmt);
    };
}
