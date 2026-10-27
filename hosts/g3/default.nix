{
  inputs,
  lib,
  self,
}:

lib.nixos.mkHost {
  # hostname = "g3";
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    users = import ./users.nix;
  };

  modules = [
    ./configuration.nix
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
  ];
}
