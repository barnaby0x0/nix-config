{
  self,
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  # imports = map (
  #   imp:
  #   lib.attrByPath (lib.splitString "." imp) (throw "Import Home Manager introuvable : ${imp}") self
  # ) (userConfig.imports or [ ]);

  # home.username = userConfig.username;
  # home.homeDirectory = userConfig.homeDirectory;

  # programs.alacritty = {
  #   enable = true;
  #   theme = "solarized_dark";
  # };

  # programs.awscli.enable = true;

  home.username = lib.mkDefault (userConfig.username or "user");
  home.homeDirectory = lib.mkDefault (userConfig.homeDirectory or "/home/user");
  home.stateVersion = userConfig.home.stateVersion;

  my.user.git = userConfig.git;
  my.programs = userConfig.programs or { };

  home.packages = map (package: pkgs.${package}) (userConfig.packages or [ ]);

  xdg.configFile = userConfig.xdgConfigFiles or { };

  home.file = userConfig.homeFiles or { };

  home.persistence."/nix/persist" = {
    directories = userConfig.persistence.directories or [ ];
    files = userConfig.persistence.files or [ ];
  };
}
