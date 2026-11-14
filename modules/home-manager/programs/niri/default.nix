# modules/home-manager/programs/niri/default.nix
{
  imports = [
    ./compositor
    ./waybar
    ./rofi.nix
    ./dunst.nix
    ./swaylock.nix
    ./swayidle.nix
    ./cliphist.nix
    ./gammastep.nix
    ./polkit.nix
    ./nm-applet.nix
    ./portal.nix
    ./theme.nix
    ./fonts.nix
  ];
}
