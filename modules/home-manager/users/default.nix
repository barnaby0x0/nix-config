{
  self,
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  home.username = lib.mkDefault (userConfig.username or "user");
  home.homeDirectory = lib.mkDefault (userConfig.homeDirectory or "/home/user");
  home.stateVersion = userConfig.home.stateVersion or "26.05";

  # ------------------------------------------------------------------
  # Compatibilité avec l'ancien format « variables »
  # (utile tant que certains hosts n'ont pas migré vers homeModule)
  # ------------------------------------------------------------------
  my.user.git = lib.mkDefault (userConfig.git or { });
  my.programs = lib.mkDefault (userConfig.myprograms or { });
  programs = lib.mkDefault (userConfig.programs or { });

  home.packages = map (package: pkgs.${package}) (userConfig.packages or [ ]);

  xdg.configFile = userConfig.xdgConfigFiles or { };

  home.file = userConfig.homeFiles or { };

  home.persistence."/nix/persist" = lib.mkIf (userConfig ? persistence) {
    directories = userConfig.persistence.directories or [ ];
    files = userConfig.persistence.files or [ ];
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Et éventuellement
  # dconf.settings."org/gnome/desktop/interface" = {
  #   cursor-theme = "Adwaita";
  #   cursor-size = 24;
  # };

}
