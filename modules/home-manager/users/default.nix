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
  my.programs = userConfig.programs or { };

  home.packages = map (package: pkgs.${package}) (userConfig.packages or [ ]);

  xdg.configFile = userConfig.xdgConfigFiles or { };

  home.file = userConfig.homeFiles or { };

  home.persistence."/nix/persist" = {
    directories = userConfig.persistence.directories or [ ];
    files = userConfig.persistence.files or [ ];
  };
}
