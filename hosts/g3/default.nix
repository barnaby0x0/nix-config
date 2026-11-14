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
    ./disko.nix
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    self.nixosModules.plasma
    self.nixosModules.garbage
    self.nixosModules.niri
    self.nixosModules.home-manager
    self.nixosModules.sops
    inputs.sops-nix.nixosModules.sops
  ];
}
