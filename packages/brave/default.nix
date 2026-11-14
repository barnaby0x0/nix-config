# packages/brave/default.nix
{ pkgsFor, ... }:

builtins.mapAttrs (_: pkgs: {
  brave = pkgs.callPackage ./package.nix { };
}) pkgsFor
