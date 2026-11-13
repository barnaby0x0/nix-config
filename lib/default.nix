{ inputs, ... }:

let
  commons = import ./commons {
    inherit inputs;
    inherit (inputs) nixpkgs;
  };
in
{
  inherit commons;

  homeManager = import ./home-manager {
    inherit (inputs) nixpkgs home-manager;
    inherit (commons) unfree;
  };

  vim = import ./vim;

  hashicorp = import ./hashicorp;

  # lib/default.nix
  nixos = import ./nixos.nix {
    inherit (inputs) nixpkgs;
    inherit (commons) unfree;
  };
}
