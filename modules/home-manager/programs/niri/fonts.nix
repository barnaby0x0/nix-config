{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.fonts;
in
{
  options.my.programs.fonts = {
    enable = lib.mkEnableOption "polices Nerd Font utilisées par la pile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.proggy-clean-tt
    ];

    fonts.fontconfig.enable = true;
  };
}
