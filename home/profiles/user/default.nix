{ ... }:

{

  my.user.git = {
    name = "Victor";
    email = "victor@mail.com";
  };

  imports = [
    # ../../../modules/home-manager/options
    # ../../../modules/home-manager/programs/common.nix
    # ../../../modules/home-manager/programs/shell.nix
    # ../../../modules/home-manager/programs/git.nix
    # ../../../modules/home-manager/programs/vim.nix
    # ../../../modules/home-manager/programs/terminator.nix
    # ../../../modules/home-manager/programs/tmux.nix
    self.homeModulesOpt.options.git

    self.homeModules.programs.common
    self.homeModules.programs.shell
    self.homeModules.programs.git
    self.homeModules.programs.vim
    self.homeModules.programs.terminator
    self.homeModules.programs.tmux
  ];
}
