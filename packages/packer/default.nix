{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) hashicorp_platforms packer_hashes forAllSystems;

  version = "1.16.2";
  platforms = hashicorp_platforms;
  hashes = packer_hashes;

  # mkTerraform = import ../../lib/terraform;
  mkPacker = self.lib.packer;

in
forAllSystems (system: {
  packer = mkPacker {
    pkgs = mkPkgs system;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
})
