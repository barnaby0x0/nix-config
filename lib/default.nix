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

  terraform = import ./hashicorp/terraform.nix;
  packer = import ./hashicorp/packer.nix;
  vault = import ./hashicorp/vault.nix;

  nixos = import ./nixos.nix {
    inherit (inputs) nixpkgs;
  };
}
