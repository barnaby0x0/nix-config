{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # imports = [
  #   ./apps.nix
  #   self.nixosModules.plasma
  #   ./disko.nix
  #   ./hardware-configuration.nix
  #   ./home-manager.nix
  # ];

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
      "size=20%"
      "mode=755"
    ];
  };

  # Identité et paramètres de base
  networking.hostName = "g3";
  networking.networkmanager.enable = true;

  networking.resolvconf.enable = false;
  # S'assurer que resolved n'interfère pas
  services.resolved.enable = false;
  environment.etc."resolv.conf" = {
    mode = "0644";
    text = ''
      nameserver 10.1.0.51
      nameserver 1.1.1.1
      search lan
    '';
  };

  time.timeZone = "Europe/Zurich";
  console.keyMap = "fr";

  i18n.defaultLocale = "fr_FR.UTF-8";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # nixpkgs.overlays = [ self.overlays.brave ];

  # Outils de diagnostic
  environment.systemPackages = with pkgs; [
    # brave
    # cloudflared
    cowsay
    curl
    git
    lolcat
    openssl
    pciutils
    tcpdump
    usbutils
    vim
    wget
    tig
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      jnoortheen.nix-ide
    ];
  };

  environment.persistence."/nix/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/lib/sops-nix"
      "/var/log"
      # "/etc/cloudflared"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.user = {
      directories = [
        ".config"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"
        {
          directory = "workspace";
          mode = "0700";
        }
      ];
      files = [
        ".bash_history"
        ".gitconfig"
      ];
    };
  };

  users.mutableUsers = false;
  users.users.user = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    home = "/home/user";
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1oFq0GYt8j7vg2nNAJNzwBtqrdOUDp8CMQwLRiz4Vz user@ull"
    ];

    # Use mkpasswd
    initialHashedPassword = "$y$j9T$TvYwvyoJ.v1jj64tTF5K61$jDWwkEw/owyBks.6xLwYIlKcLD4MJ4G062UAm757N/4";
  };

  users.users.colmena = {
    isNormalUser = true;
    home = "/var/lib/colmena";
    createHome = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1oFq0GYt8j7vg2nNAJNzwBtqrdOUDp8CMQwLRiz4Vz user@ull"
    ];
  };

  services.displayManager.hiddenUsers = [ "colmena" ];

  nix.settings.trusted-users = [
    "root"
    "colmena"
  ];

  security.sudo.extraRules = [
    {
      users = [ "colmena" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  security.sudo.wheelNeedsPassword = true;
  security.pki.certificateFiles = [
    ./certs/proxlab-ca.crt
  ];

  services.openssh = {
    enable = true;
    #logLevel = "DEBUG3";
    openFirewall = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
    };

    hostKeys = [
      {
        path = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/daaku/caddy-ssh@v0.10.0"
      ];

      hash = "sha256-MhzeZOj4qOIKDwGg0Poz6IAsh+OvSWxIBeSrBwU4NXo=";
    };

    virtualHosts."g3.proxlab.cc:8443" = {
      extraConfig = ''
        tls internal

        route {
          ssh 127.0.0.1:22
          respond "Not found" 404
        }
      '';
    };

  };

  # systemd.services.cloudflared = {
  #   description = "Cloudflare Tunnel";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network-online.target" ];
  #   wants = [ "network-online.target" ];

  #   serviceConfig = {
  #     ExecStart = "/run/current-system/sw/bin/cloudflared tunnel run --token-file /etc/cloudflared/token";
  #     Restart = "always";
  #     RestartSec = "5s";
  #   };
  # };

  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 5d";
  # };

  # nix.settings.auto-optimise-store = true;
  # boot.loader.systemd-boot.configurationLimit = 5;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
