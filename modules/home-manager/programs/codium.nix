# modules/home-manager/programs/codium.nix
{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.my.programs.codium;
  marketplace =
    self.inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in
{
  options.my.programs.codium.enable = lib.mkEnableOption "Codium";
  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = [
        marketplace.jnoortheen.nix-ide
      ];
    };
  };
}
