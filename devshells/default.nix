{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
in
forAllSystems (
  system:
  let
    pkgs = mkPkgs system;
  in
  {
    default = pkgs.mkShell {
      packages = [
        self.packages.${system}.nixdot
      ];
    };
  }
)
