{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "26.05";

  # Boot UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Racine éphémère en RAM
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=25%"
      "mode=755"
    ];
  };

  # Identité et paramètres de base
  networking.hostName = "g3";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";
  console.keyMap = "fr";

  i18n.defaultLocale = "fr_FR.UTF-8";

  # Outils de diagnostic
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    btop
    pciutils
    usbutils
  ];

  environment.persistence."/nix/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/log"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.user = {
      directories = [
        "documents"
      ];
    };
  };

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Nix Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
