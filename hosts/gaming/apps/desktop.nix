{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # akm
    baobab
    # discover
    geany
    libreoffice
    rpi-imager
    skanpage
    terminator
    tilda
    transmission-gtk
  ];
}
