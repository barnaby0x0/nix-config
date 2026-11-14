# modules/home-manager/programs/vim.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.vim;
in
{
  options.my.programs.vim.enable = lib.mkEnableOption "Vim";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.callPackage ../../../packages/vim/package.nix { })
    ];
  };
}
