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
      extensions = [
        {
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
        } # dark-reader
      ];
      commandLineArgs = [
        "--disk-cache-dir=/tmp/brave/cache"
        "--gpu-cache-dir=/tmp/brave/gpu-cache"
      ];
    };
  };
}
