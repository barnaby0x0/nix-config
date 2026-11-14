# lib/commons/default.nix
{ inputs, unfreePackages, ... }:

let
  unfree = import ./unfree.nix inputs.nixpkgs.lib unfreePackages;
in

{
  inherit unfree;
  system = import ./system.nix { inherit inputs; };
  mkPkgs = import ./pkgs.nix {
    inherit (inputs) nixpkgs;
    inherit unfree;
  };
}
