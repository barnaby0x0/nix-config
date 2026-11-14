{ inputs, unfreePackages, ... }:

let
  commons = import ./commons { inherit inputs unfreePackages; };
in
{
  inherit commons;

  homeManager = import ./home-manager {
    inherit (inputs) nixpkgs home-manager;
    inherit (commons) mkPkgs;
  };

  # vim = import ./vim;

  hashicorp = import ./hashicorp;

  # lib/default.nix
  nixos = import ./nixos.nix {
    inherit (inputs) nixpkgs;
    inherit (commons) unfree;
  };
}
