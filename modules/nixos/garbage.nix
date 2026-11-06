{ ... }:

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };

  nix.settings.auto-optimise-store = true;
  boot.loader.systemd-boot.configurationLimit = 5;
}
