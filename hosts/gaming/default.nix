{ inputs, self }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    users = import ./users.nix;
  };

  modules = [
    ./system.nix
    # ./nix-settings.nix
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
