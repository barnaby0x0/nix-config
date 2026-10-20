{ pkgs, mkVim, ... }:

let
  vimPackage = mkVim {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  home.packages = [ vimPackage ];
}
