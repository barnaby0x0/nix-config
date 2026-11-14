{
  self,
  userConfig,
  ...
}:

{
  imports = [
    self.homeModules.programs.git
    self.homeModules.programs.vim
  ];

  my.user.git = {
    name = userConfig.git.name;
    email = userConfig.git.email;
  };
}
