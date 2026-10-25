{
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/nixos/desktop/plasma.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];

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

  systemd.tmpfiles.rules = [
    "d /home/user 0700 user users -"
    "d /home/user/.local 0755 user users -"
    "d /home/user/.steam 0755 user users -"
  ];

  #hardware.cpu.vendor = "amd";
  # cachyos.cpu = "amd";

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

  # S'assurer que resolved n'interfère pas
  services.resolved.enable = false;

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
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.zsh.enable = true;

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
        "Downloads"

        # Steam : configuration, utilisateurs et préfixes Proton
        ".local/share/Steam"
        ".steam"

        # État des applications utilisateur
        ".local/state"

        # KDE : données et état des composants
        ".config/KDE"
        ".config/kde.org"
        ".config/plasma-workspace"
      ];

      files = [
        # Zsh / Powerlevel10k
        ".zsh_history"
        ".p10k.zsh"

        # KDE Plasma : préférences
        ".config/kdeglobals"
        ".config/kglobalshortcutsrc"
        ".config/kwinrc"
        ".config/kwinoutputconfig.json"
        ".config/kwinrulesrc"
        ".config/plasma-org.kde.plasma.desktop-appletsrc"
        ".config/plasmashellrc"
        ".config/plasmarc"
        ".config/kactivitymanagerdrc"
        ".config/dolphinrc"
        ".config/kiorc"
        ".config/konsolerc"
        ".config/powermanagementprofilesrc"
        ".config/plasma-localerc"
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

  security.sudo.wheelNeedsPassword = true;
  security.pki.certificateFiles = [
    ./certs/proxlab-ca.crt
  ];

  environment.etc."resov.conf".text = ''
    nameserver 1.1.1.1
    nameserver 10.1.0.51
  '';

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    pciutils
    usbutils
    htop
    btop
    fastfetch
    brave
    zsh
    vscodium
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    trusted-users = [
      "root"
      "user"
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
}
