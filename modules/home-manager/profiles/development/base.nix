{ pkgs, ... }:

{
  imports = [
    ../../programs/git.nix
    ../../programs/vim.nix
    ../../programs/tmux.nix
  ];

  home.packages = with pkgs; [
    lolcat
  ];
}
