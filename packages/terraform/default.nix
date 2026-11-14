# packages/terraform/default.nix

{
  pkgsFor,
  lib,
  self,
  ...
}:
let
  inherit (lib.commons.system) hashicorp_platforms terraform_hashes forAllSystems;

  version = "1.17.0";
  platforms = hashicorp_platforms;
  hashes = terraform_hashes;

in
builtins.mapAttrs (system: pkgs: {
  terraform = self.lib.hashicorp.terraform {
    inherit pkgs;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };

}) pkgsFor
