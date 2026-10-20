{pkgs, ...}:
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
}