# packages/vim/default.nix
# {
#   self,
#   inputs,
#   lib,
# }:
# let
#   inherit (lib.commons) mkPkgs;
#   inherit (lib.commons.system) forAllSystems;
# in
# forAllSystems (system: {
#   vim = (mkPkgs system).callPackage ./package.nix { };
# })

# packages/vim/default.nix
{ pkgsFor, ... }:

builtins.mapAttrs (_: pkgs: {
  vim = pkgs.callPackage ./package.nix { };
}) pkgsFor
