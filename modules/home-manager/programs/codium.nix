
# modules/home-manager/programs/codium.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.codium;
in

{
  options.my.programs.codium.enable = lib.mkEnableOption "Codium";
  config = lib.mkIf cfg.enable {
      programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions =
      with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace; [
        jnoortheen.nix-ide
      ];
  };
  };
}




