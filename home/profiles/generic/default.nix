{ self, userConfig, mkVim, ... }:

{
  imports = [
    # ../../../modules/home-manager
    self.homeModules.default
  ];

  my.user.git = {
    name = userConfig.git.name;
    email = userConfig.git.email;
  };
}
