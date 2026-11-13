{ inputs, ... }:

let
  commons = import ./commons { inherit inputs; };
in
{
  inherit commons;

 homeManager = import ./home-manager {
    inherit (inputs) nixpkgs home-manager;
    inherit (commons) unfree;
  };

  vim = import ./vim;

  # terraform = import ./hashicorp/terraform.nix;
  # packer = import ./hashicorp/packer.nix;
  # vault = import ./hashicorp/vault.nix;

  hashicorp = import ./hashicorp;

  nixos = import ./nixos.nix {
    inherit (inputs) nixpkgs;
  };
}
