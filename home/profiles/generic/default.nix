{
  self,
  userConfig,
  mkVim,
  ...
}:

{
  imports = [
    # ../../../modules/home-manager
    # self.homeModules.default
    self.homeModules.args
    self.homeModules.programs.git
    self.homeModules.programs.vim
    # self.homeModules.profiles.desktop
  ];

  my.user.git = {
    name = userConfig.git.name;
    email = userConfig.git.email;
  };
}
