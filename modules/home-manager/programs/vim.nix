# modules/home-manager/programs/vim.nix
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.my.programs.vim;
  inherit ((import ../../../lib/vim)) mkVim;
in
{
  options.my.programs.vim.enable = lib.mkEnableOption "Vim";
  config = lib.mkIf cfg.enable {
    home.packages = [ (mkVim pkgs) ];
  };
}
