{ lib, pkgs, ... }:

{
  programs.niri = {
    enable = true;
    # Fait de Nautilus le sélecteur de fichiers du portail (ne l'installe pas)
    useNautilus = true;
  };

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
