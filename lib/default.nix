{ inputs, ... }:

{
  commons = import ./commons {
    inherit inputs;
  };

  homeManager = import ./home-manager {
    inherit (inputs) nixpkgs home-manager;
  };

  vim = import ./vim {
    inherit (inputs) nixpkgs;
  };

  terraform = import ./terraform {
    inherit (inputs) nixpkgs;
  };

  nixos = import ./nixos.nix {
    inherit (inputs) nixpkgs;
  };
}
