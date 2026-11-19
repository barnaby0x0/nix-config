{ ... }:

{
  programs.noctalia = {
    enable = true;

    settings = {
      theme.mode = "dark";
      bar.default = {
        position = "bottom";
        auto_hide = false;
        margin_ends = 0; # pleine largeur
        margin_edge = 0; # collée au bord
        radius = 0; # coins carrés
      };

      wallpaper = {
        directory = "/home/user/.wallpapers";
        automation = {
          enabled = true;
          interval_seconds = 1800;
          order = "random";
          pause_on_fullscreen = false;
          recursive = true;
        };
      };
    };
  };
}
