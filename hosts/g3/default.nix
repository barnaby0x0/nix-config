{
  inputs,
  lib,
  self,
}:

lib.nixos.mkHost {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    users = import ./users.nix;
  };

  modules = [
    ./apps.nix
    ./configuration.nix
    ./home-manager.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
  ];
}
