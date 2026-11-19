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
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    # self.homeModules.profiles.base
    self.nixosModules.garbage
    self.nixosModules.home-manager
    self.nixosModules.niri
    self.nixosModules.plasma
    self.nixosModules.sops
    self.nixosModules.hardening
    inputs.sops-nix.nixosModules.sops
    { services.flatpak.enable = true; }
  ];
}
