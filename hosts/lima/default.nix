{
  inputs,
  lib,
  self,
}:

lib.nixos.mkHost {
  system = "aarch64-linux";

  specialArgs = {
    inherit inputs self;
  };

  modules = [
    ./configuration.nix
    inputs.nixos-lima.nixosModules.lima
  ];
}
