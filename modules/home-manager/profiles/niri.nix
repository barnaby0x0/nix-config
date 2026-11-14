{ self, ... }:

{
  imports = [ self.homeModules.profiles.base ];

  my.programs = {
    niri = {
      enable = true;
      output = "eDP-1";
      scale = 1.0;
      terminal = "terminator";
      layout = "fr";
    };

    # Pile Wayland utilisée par les raccourcis et les services de niri
    rofi.enable = true;
    dunst.enable = true;
    waybar.enable = true;
    swaylock.enable = true;
    swayidle.enable = true;
    cliphist.enable = true;
    gammastep.enable = true;
    polkit.enable = true;
    nm-applet.enable = true;
    portal.enable = true;
    theme.enable = true;
    fonts.enable = true;
  };
}
