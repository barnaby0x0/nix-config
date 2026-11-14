# packages/packer/default.nix
{
  self,
  lib,
  pkgsFor,
  ...
}:

let
  inherit (lib.commons.system) hashicorp_platforms packer_hashes forAllSystems;

  version = "1.16.2";
  platforms = hashicorp_platforms;
  hashes = packer_hashes;

in
builtins.mapAttrs (system: pkgs: {
  packer = self.lib.hashicorp.packer {
    inherit pkgs;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
}) pkgsFor
