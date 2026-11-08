{
  self,
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  imports = map (
    imp:
    lib.attrByPath (lib.splitString "." imp) (throw "Import Home Manager introuvable : ${imp}") self
  ) (userConfig.imports or [ ]);

  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = userConfig.home.stateVersion;

  my.user.git = userConfig.git;

  home.packages = map (package: pkgs.${package}) (userConfig.packages or [ ]);

  xdg.configFile = userConfig.xdgConfigFiles or { };

  home.file = userConfig.homeFiles or { };

  home.persistence."/nix/persist" = {
    directories = userConfig.persistence.directories or [ ];
    files = userConfig.persistence.files or [ ];
  };
}
