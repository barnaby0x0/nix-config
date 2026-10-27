{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.commons.system) forAllSystems;

  homeManagerPackages = import ./home-manager {
    inherit self inputs lib;
  };

  terraformPackages = import ./terraform {
    inherit self inputs lib;
  };

  vimPackages = import ./vim {
    inherit self inputs lib;
  };

in
forAllSystems (
  system:
  homeManagerPackages.${system}
  // terraformPackages.${system}
  // vimPackages.${system}
  // inputs.nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
    iso-installer = self.nixosConfigurations."installer-${system}".config.system.build.isoImage;
  }
)
