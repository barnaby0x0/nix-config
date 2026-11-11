{ ... }:

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    persistent = true;
    options = "--delete-older-than 5d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "04:00" ];
  };

  boot.loader.systemd-boot.configurationLimit = 5;
}
