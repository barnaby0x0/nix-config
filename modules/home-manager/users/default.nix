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
  home.stateVersion = userConfig.home.stateVersion;

  my.user.git = userConfig.git or { };
  my.programs = userConfig.myprograms or { };
  programs = userConfig.programs or { };

  home.packages = map (package: pkgs.${package}) (userConfig.packages or [ ]);

  xdg.configFile = userConfig.xdgConfigFiles or { };

  home.file = userConfig.homeFiles or { };

  home.persistence."/nix/persist" = {
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
