{ inputs, ... }:

{
  commons = import ./commons {
    inherit inputs;
  };

  homeManager = import ./home-manager {
    inherit (inputs) nixpkgs home-manager;
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
