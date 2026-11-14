{ self, ... }:

{

  imports = [
    self.homeModules.profiles.base
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
