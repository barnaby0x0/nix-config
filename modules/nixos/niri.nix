{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    # Fait de Nautilus le sélecteur de fichiers du portail (ne l'installe pas)
    useNautilus = true;
  };

  environment.systemPackages = with pkgs; [
    # Terminal de secours et accès au système si la config utilisateur casse
    alacritty
    xwayland-satellite
    nautilus
    vim
    # Tous utilisés par les scripts niri, mais gardés au niveau système pour
    # pouvoir faire de la maintenance même si les scripts cassent
    brightnessctl
    wireplumber
    wl-clipboard
  ];

  # Requis par les réglages dconf du thème (modules Home Manager)
  programs.dconf.enable = true;

  # Agent d'authentification (mate-polkit côté utilisateur)
  security.polkit.enable = true;

  # Service PAM de swaylock : mot de passe, et empreinte si services.fprintd
  # est activé sur la machine
  security.pam.services.swaylock = { };
}
