{ ... }:

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "30min"; # évite le pic d'I/O pile au boot
    options = "--delete-older-than 5d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
    persistent = true;
    randomizedDelaySec = "1h";
  };

  boot.loader.systemd-boot.configurationLimit = 5;
}
