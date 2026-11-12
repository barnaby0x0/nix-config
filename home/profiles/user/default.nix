{ self, ... }:

{

  imports = [
    self.homeModules.profiles.base
    # self.homeModules.args
    # self.homeModules.programs.git

    # self.homeModules.programs.common
    # self.homeModules.programs.shell
    # self.homeModules.programs.git
    # self.homeModules.programs.vim
    # self.homeModules.programs.terminator
    # self.homeModules.programs.tmux
  ];

  my.user.git = {
    name = "Victor";
    email = "victor@mail.com";
  };

  my.programs = {
    zsh.enable = true;
    git.enable = true;
    vim.enable = true;
    terminator.enable = true;
    tmux.enable = true;
  };
}
