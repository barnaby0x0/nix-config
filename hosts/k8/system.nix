{
  pkgs,
  self,
  ...
}:

{
  # imports = [
  #   ../../modules/nixos/desktop/plasma.nix
  #   ./disko.nix
  #   ./hardware-configuration.nix
  # ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=25%"
      "mode=755"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "none"; # Empêche NetworkManager d'écraser resolv.conf
    };
  };

  networking.resolvconf.enable = false;
  networking.hostName = "k8";

  # S'assurer que resolved n'interfère pas
  services.resolved.enable = false;
  services.pcscd.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.debian.pcsc-lite.access_pcsc" &&
        subject.isInGroup("wheel")
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  # Fichier statique
  environment.etc."resolv.conf" = {
    mode = "0644";
    text = ''
      nameserver 10.1.0.51
      nameserver 1.1.1.1
      search lan
    '';
  };

  time.timeZone = "Europe/Zurich";

  i18n = {
    defaultLocale = "fr_FR.UTF-8";

    supportedLocales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  console.keyMap = "fr";
  # services.xserver = {
  #   xkb.layout = "fr";
  # };

  services.blueman.enable = true;

  services.openssh = {
    enable = true;

    hostKeys = [
      {
        path = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.persistence."/nix/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/log"
      "/var/lib/sops-nix"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.user = {
      directories = [
        ".config"
        ".dotfiles"
        ".hist"
        ".local"
        ".local/state/nix-config"
        ".password-store"
        ".secret"
        ".steam"
        "Bureau"
        "Documents"
        "Downloads"
        "Pictures"
        "Téléchargements"
        "Videos"
        "Workspace"
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

        {
          directory = ".zsh";
          mode = "0700";
        }
      ];
      files = [
        ".p10k.zsh"
        ".bash_history"
        ".gitconfig"
      ];
    };
  };

  users.users.user.shell = pkgs.zsh;
  users.mutableUsers = false;
  users.users.user = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "audio"
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

  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = true;
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
  security.pki.certificateFiles = [
    ./certs/proxlab-ca.crt
  ];

  environment.etc."resov.conf".text = ''
    nameserver 1.1.1.1
    nameserver 10.1.0.51
  '';

  environment.systemPackages = with pkgs; [
    fzf
    go
    curl
    fastfetch
    file
    git
    gnupg
    lolcat
    pciutils
    self.packages.${system}.bootstrap
    usbutils
    vscodium
    wget
    zsh
    sops
    age
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
    settings = {
      default-cache-ttl = 34560000;
      max-cache-ttl = 34560000;
    };
  };

  # nix.settings.experimental-features = [
  #   "nix-command"
  #   "flakes"
  # ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "user"
      "colmena"
    ];

    # substituters = [
    #   "https://cache.nixos.org/"
    #   "https://attic.xuyh0120.win/lantian"
    # ];

    # trusted-public-keys = [
    #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #   "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    # ];
  };

  # dans un module de l'hôte k8, temporairement
}
