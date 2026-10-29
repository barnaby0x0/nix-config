{
  inputs,
  lib,
  self,
}:

let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
in
map (system: {
  name = "installer-${system}";

  value = lib.nixos.mkHost {
    inherit system;

    specialArgs = {
      inherit inputs self;
    };

    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
      ./configuration.nix
    ];
  };
}) systems
