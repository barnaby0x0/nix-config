{ self, ... }:

{
  imports = [
    self.homeModules.profiles.base
    # Module Home Manager de Noctalia, exposé par le flake (homeModules.noctalia)
    self.homeModules.noctalia
  ];

  my.programs = {
    niri = {
      enable = true;
      terminal = "terminator";
      layout = "fr";
    };

    # Noctalia ne fournit ni agent polkit, ni portails, ni thème GTK/Qt
    polkit.enable = true;
    portal.enable = true;
    theme.enable = false;
  };

  # Barre, lanceur, notifications, verrouillage, presse-papiers, fond d'écran,
  # veille, lumière nocturne... Les réglages vont dans `settings` (TOML).

  # programs.noctalia = {
  #   enable = true;

  #   settings = {
  #     theme.mode = "dark";
  #     bar.default = {
  #       position = "bottom";
  #       auto_hide = true;
  #     };
  #   };
  # };
}
