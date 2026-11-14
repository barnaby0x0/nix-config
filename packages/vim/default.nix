# packages/vim/default.nix
{ pkgsFor, ... }:

builtins.mapAttrs (_: pkgs: {
  vim = pkgs.callPackage ./package.nix { };
}) pkgsFor
