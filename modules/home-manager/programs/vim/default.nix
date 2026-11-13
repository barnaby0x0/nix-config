# { config, lib, pkgs, ... }:

# let
#   cfg = config.my.programs.vim;

#   vimPackage = (import ../../../lib/vim {
#     nixpkgs = pkgs.path;
#   }).mkVim {
#     system = pkgs.stdenv.hostPlatform.system;
#   };

# in
# {
#   options.my.programs.vim.enable = lib.mkEnableOption "Vim";

#   config = lib.mkIf cfg.enable {
#     home.packages = [ vimPackage ];
#   };
# }

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.vim;

  vimPackage = pkgs.vim-full.customize {
    name = "vim";

    vimrcConfig.customRC = builtins.readFile ./vimrc;

    vimrcConfig.packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        onedark-vim
        nerdtree
        nerdtree-git-plugin
        vim-devicons
        vim-nerdtree-syntax-highlight
        goyo-vim
        nerdcommenter
        vim-gitgutter
        vim-markdown
        nginx-vim
        vim-terraform
        vim-toml
        vim-vagrant
        vim-yaml
        vim-surround
        vim-gnupg
      ];
    };
  };

in
{
  options.my.programs.vim.enable = lib.mkEnableOption "Vim";

  config = lib.mkIf cfg.enable {
    home.packages = [ vimPackage ];
  };
}
