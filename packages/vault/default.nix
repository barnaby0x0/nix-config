{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.commons) mkPkgs;
  inherit (lib.commons.system) hashicorp_platforms vault_hashes forAllSystems;

  version = "2.2.1";
  platforms = hashicorp_platforms;
  hashes = vault_hashes;

in
forAllSystems (system: {
  vault = self.lib.hashicorp.vault {
    pkgs = mkPkgs system;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
})
