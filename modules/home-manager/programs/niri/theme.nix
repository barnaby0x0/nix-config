{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.theme;
in
{
  options.my.programs.theme = {
    enable = lib.mkEnableOption "thème GTK/Qt sombre (Adwaita, Nord)";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
      font = {
        name = "Ubuntu Sans";
        package = pkgs.ubuntu-sans;
        size = 12;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Adwaita";
        cursor-size = 24;
        font-name = "Ubuntu Sans 12";
        document-font-name = "Ubuntu Sans 12";
        monospace-font-name = "Ubuntu Sans Mono 12";
        font-antialiasing = "rgba";
        font-hinting = "slight";
      };
    };
  };
}
