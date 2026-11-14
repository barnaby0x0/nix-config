# packages/vim/package.nix
{ vim-full, vimPlugins }:
vim-full.customize {
  name = "vim";
  vimrcConfig.customRC = builtins.readFile ./vimrc;
  vimrcConfig.packages.myPlugins.start = with vimPlugins; [
    # …
  ];
}
