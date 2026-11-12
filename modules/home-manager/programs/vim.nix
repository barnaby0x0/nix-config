{
  config,
  lib,
  pkgs,
  mkVim,
  ...
}:

let
  cfg = config.my.programs.vim;

  vimPackage = mkVim {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  options.my.programs.vim.enable = lib.mkEnableOption "Vim";

  config = lib.mkIf cfg.enable {
    home.packages = [ vimPackage ];
  };
}
