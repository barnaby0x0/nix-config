{ inputs, ... }:
rec {
  system = import ./system.nix { inherit inputs; };
  unfree = import ./unfree.nix inputs.nixpkgs.lib;
  mkPkgs = import ./pkgs.nix { inherit (inputs) nixpkgs; inherit unfree; };
}
