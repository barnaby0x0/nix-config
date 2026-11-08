{
  nixpkgs,
}:

let
  inherit (nixpkgs) lib;
in

# Usage : resolveHomeImports self (userConfig.imports or [ ])
self: imports:
map (
  imp:
  lib.attrByPath (lib.splitString "." imp) (throw "Import Home Manager introuvable : ${imp}") self
) imports
