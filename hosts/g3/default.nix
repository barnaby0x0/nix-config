{
  inputs,
  lib,
  self,
  nixpkgsInput ? inputs.nixpkgs,
}:

lib.nixos.mkHost {
  inherit nixpkgsInput;
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    users = import ./users { inherit self; };
  };

  modules = [
    ./apps.nix
    ./configuration.nix
    # ./disko.nix # defined bellow
    ./hardware-configuration.nix
    ./modules.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    self.nixosModules.garbage
    self.nixosModules.home-manager
    # self.nixosModules.niri
    self.nixosModules.plasma
    self.nixosModules.hardening
    # self.nixosModules.sops
    # inputs.sops-nix.nixosModules.sops
    { services.flatpak.enable = true; }
    self.nixosModules.disk
    self.nixosModules.services
    {
      custom.disk = {
        encrypt = false;
        # luksPasswordFile = "/tmp/luks.key";
        device = "/dev/nvme0n1";
      };
    }
  ];
}
