{ nixpkgs }:
let
  mkVim =
    { system }:
    let
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "vim-yaml"
          ];
      };
    in
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
in
{
  inherit mkVim;
}
