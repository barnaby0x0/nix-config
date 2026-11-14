# modules/home-manager/programs/brave.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.brave;
in

{
  options.my.programs.brave.enable = lib.mkEnableOption "Brave";
  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = import ../../../packages/brave/args.nix;
      extensions = [
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark-reader
      ];
    };
  };
}
