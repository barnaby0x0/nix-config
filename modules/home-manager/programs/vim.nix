{ pkgs, lib, ... }:

let
  vimPackage = lib.vim.mkVim {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  home.packages = [ vimPackage ];
}
