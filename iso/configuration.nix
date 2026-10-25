{ config, pkgs, ... }:

{
  system.stateVersion = "26.05";

  networking.hostName = "installer";
  networking.networkmanager.enable = true;

  # Accès SSH à l'ISO live
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1oFq0GYt8j7vg2nNAJNzwBtqrdOUDp8CMQwLRiz4Vz user@ull"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Outils nécessaires à l'installation
  environment.systemPackages = with pkgs; [
    cloud-init
    parted
    e2fsprogs
    dosfstools
    util-linux
    gptfdisk
    vim
    git
    curl
    wget
    nixos-install-tools
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Réseau géré par NetworkManager
  networking.useNetworkd = false;

  # Scripts embarqués dans l'ISO
  environment.etc."root/scripts/install.sh".source = ./scripts/install.sh;

  # Accès pratique depuis /root/scripts
  system.activationScripts.rootScripts.text = ''
    mkdir -p /root/scripts
    ln -sfn /etc/root/scripts/install.sh /root/scripts/install.sh
  '';
}
