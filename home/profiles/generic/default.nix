{ userConfig, mkVim, ... }:

{
  imports = [
    ../../../modules/home-manager/options
    ../../../modules/home-manager/programs/common.nix
    ../../../modules/home-manager/programs/shell.nix
    ../../../modules/home-manager/programs/git.nix
    ../../../modules/home-manager/programs/vim.nix
    ../../../modules/home-manager/programs/terminator.nix
    ../../../modules/home-manager/programs/tmux.nix
  ];

  my.user.git = {
    name = userConfig.git.name;
    email = userConfig.git.email;
  };
}
