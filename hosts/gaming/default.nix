{
  inputs,
  lib,
  self,
}:

lib.nixos.mkHost {
  # hostname = "gaming";
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    users = import ./users.nix;
  };

  modules = [
    ./system.nix
    ./apps.nix
    ./overlays.nix
    ../../modules/nixos/cachyos2.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/performance.nix
    ../../modules/nixos/virt.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    ./home-manager.nix
  ];
}
