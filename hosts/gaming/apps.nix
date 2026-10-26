{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    pciutils
    usbutils
    htop
    btop
    fastfetch
    brave
    zsh
    vscodium
    lolcat
  ];
}
