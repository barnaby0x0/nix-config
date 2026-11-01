{
  inputs,
  lib,
  self,
}:

lib.nixos.mkHost {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    # users = import ./users.nix;
  };

  modules = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    ./configuration.nix
  ];
}
