{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bc
    cdrtools
    earlyoom
    exiftool
    flatpak
    inotify-tools
    lshw
    ntfsprogs
    # perl-image-exiftool
    stow
    # ttf-agave-nerd
    # ttf-dejavu
    # tui-journal
    wl-clipboard
  ];
}
