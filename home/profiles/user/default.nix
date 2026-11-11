{ self, ... }:

{

  my.user.git = {
    name = "Victor";
    email = "victor@mail.com";
  };

  imports = [
    self.homeModules.args
    self.homeModules.programs.git

    self.homeModules.programs.common
    self.homeModules.programs.shell
    self.homeModules.programs.git
    self.homeModules.programs.vim
    self.homeModules.programs.terminator
    self.homeModules.programs.tmux
  ];
}
