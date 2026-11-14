# packages/vault/default.nix
# {
#   self,
#   inputs,
#   lib,
# }:
{
  pkgsFor,
  lib,
  self,
  ...
}:

let
  # inherit (lib.commons) mkPkgs;
  inherit (lib.commons.system) hashicorp_platforms vault_hashes forAllSystems;

  version = "2.2.1";
  platforms = hashicorp_platforms;
  hashes = vault_hashes;

in
builtins.mapAttrs (system: pkgs: {
  vault = self.lib.hashicorp.vault {
    inherit pkgs;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };

}) pkgsFor

# forAllSystems (system: {
#   vault = self.lib.hashicorp.vault {
#     pkgs = mkPkgs system;
#     inherit version;
#     platform = platforms.${system};
#     hash = hashes.${system};
#   };
# })
