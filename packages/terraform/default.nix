{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.commons) mkPkgs;
  inherit (lib.commons.system) hashicorp_platforms terraform_hashes forAllSystems;

  version = "1.17.0";
  platforms = hashicorp_platforms;
  hashes = terraform_hashes;

in
forAllSystems (system: {
  terraform = self.lib.hashicorp.terraform {
    pkgs = mkPkgs system;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
})
