{ inputs, ... }:
{
  system = import ./system.nix { inherit inputs; };
  unfree = import ./unfree.nix inputs.nixpkgs.lib;
}