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
    ./disko.nix
    ./hardware-configuration.nix
    ./overlays.nix
    ./system.nix
    ./modules.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    self.buildModules.qemu-aarch64
    self.nixosModules.cachyos
    self.nixosModules.desktop
    self.nixosModules.gaming
    self.nixosModules.garbage
    self.nixosModules.home-manager
    self.nixosModules.performance
    self.nixosModules.plasma
    self.nixosModules.services
    self.nixosModules.virt
  ];
}
