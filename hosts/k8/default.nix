{
  inputs,
  lib,
  self,
}:

lib.nixos.mkHost {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    users = import ./users { inherit self; };
  };

  modules = [
    ./apps.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./overlays.nix
    ./system.nix
    ./modules.nix
    {
      services.flatpak.enable = true;
    }
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
    # self.nixosModules.plasma
    self.nixosModules.services
    self.nixosModules.virt
    self.nixosModules.niri
  ];
}
