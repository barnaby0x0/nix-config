{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) hashicorp_platforms terraform_hashes forAllSystems;

  version = "1.17.0";
  platforms = hashicorp_platforms;
  hashes = terraform_hashes;

  # mkTerraform = import ../../lib/terraform;
  mkTerraform = self.lib.terraform;

in
forAllSystems (system: {
  terraform = mkTerraform {
    pkgs = mkPkgs system;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
})
