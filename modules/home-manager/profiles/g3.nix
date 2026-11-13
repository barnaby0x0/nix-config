{ self, lib, ... }:

{

  imports = [ self.homeModules.profiles.base ];

  my.programs = {
    brave.enable = true;
    git.enable = true;
    terminator.enable = true;
    tmux.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };
}
