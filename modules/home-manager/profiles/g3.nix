{ self, lib, ... }:

{

  imports = [ self.homeModules.profiles.base ];

  my.programs.brave.enable = true;
  my.programs.git.enable = true;
  my.programs.terminator.enable = true;
  my.programs.tmux.enable = true;
  my.programs.vim.enable = true;
  my.programs.zsh.enable = true;
}
