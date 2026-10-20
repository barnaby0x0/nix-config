{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) systems forAllSystems;
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
