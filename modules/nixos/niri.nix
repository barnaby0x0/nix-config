{ lib, pkgs, ... }:

{
  programs.niri = {
    enable = true;
    # Fait de Nautilus le sélecteur de fichiers du portail (ne l'installe pas)
    useNautilus = true;
  };

  # --- Session graphique -----------------------------------------------------
  # programs.niri enregistre seulement la session « niri » : il faut un
  # gestionnaire de connexion pour la lancer (sinon le système reste sur un TTY).
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  # Pilotes Mesa (EGL / OpenGL ES). Sans eux, niri et Noctalia n'ont pas de
  # rendu : écran noir.
  hardware.graphics.enable = true;

  # --- Services que Plasma activait avant -----------------------------------
  # Audio (touches volume, OSD et centre de contrôle de Noctalia)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Polices : sans elles, Noctalia n'affiche pas de texte
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  # Le portail Secret de niri s'appuie sur gnome-keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    # Terminal de secours (utilisé par la config par défaut de niri) et accès
    # au système si la config utilisateur casse
    alacritty
    xwayland-satellite
    nautilus
    vim
    brightnessctl
    wireplumber
    wl-clipboard
  ];

  # Requis par les réglages dconf du thème (modules Home Manager)
  programs.dconf.enable = true;

  # Agent d'authentification (mate-polkit côté utilisateur)
  security.polkit.enable = true;

  # Batterie dans la barre et le centre de contrôle de Noctalia
  services.upower.enable = lib.mkDefault true;

  # L'écran de verrouillage de Noctalia s'authentifie via le service PAM `login`
  # (déjà présent sur NixOS), donc aucun service PAM dédié n'est nécessaire.
}
