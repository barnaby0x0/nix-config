{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.portal;
in
{
  options.my.programs.portal = {
    enable = lib.mkEnableOption "portails xdg (gnome + gtk)";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = [
        "gnome"
        "gtk"
      ];
    };
  };
}
