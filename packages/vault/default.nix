{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) hashicorp_platforms vault_hashes forAllSystems;

  version = "2.2.1";
  platforms = hashicorp_platforms;
  hashes = vault_hashes;

  # mkTerraform = import ../../lib/terraform;
  mkVault = self.lib.vault;

in
forAllSystems (system: {
  vault = mkVault {
    pkgs = mkPkgs system;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
})
