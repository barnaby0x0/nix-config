{ userConfig, mkVim, ... }:

{
  imports = [
    ../../../modules/home-manager
  ];

  my.user.git = {
    name = userConfig.git.name;
    email = userConfig.git.email;
  };
}
