{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    apparmor
    firejail
    firetools
    gcr
    libfido2
    lynis
    nmap
    pass
    pinentry
    qtpass
    sops
    yubikey-manager
  ];
}
