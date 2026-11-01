{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # apparmor
    firejail
    # firetools
    gcr_4
    libfido2
    lynis
    nmap
    pass
    pinentry-curses
    qtpass
    sops
    yubikey-manager
  ];
}
