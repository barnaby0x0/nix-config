# lib/vim/default.nix
{
  mkVim =
    pkgs:
    pkgs.vim-full.customize {
      name = "vim";
      vimrcConfig.customRC = builtins.readFile ./vimrc;
      vimrcConfig.packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          # Theme
          onedark-vim

          # Navigation / UI
          nerdtree
          nerdtree-git-plugin
          vim-devicons
          vim-nerdtree-syntax-highlight
          goyo-vim

          # Editing
          nerdcommenter

          # Git
          vim-gitgutter

          # Languages / formats
          vim-markdown
          nginx-vim
          vim-terraform
          vim-toml
          vim-vagrant
          vim-yaml
          vim-surround

          # Encryption
          vim-gnupg
        ];
      };
    };
}
