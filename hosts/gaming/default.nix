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
    ./system.nix
    ./apps.nix
    ./overlays.nix
    self.nixosModules.cachyos
    self.nixosModules.desktop
    self.nixosModules.gaming
    self.nixosModules.performance
    self.nixosModules.virt
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    ./home-manager.nix
  ];
}
