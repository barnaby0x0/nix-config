{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.nm-applet;
in
{
  options.my.programs.nm-applet = {
    enable = lib.mkEnableOption "nm-applet";
  };

  config = lib.mkIf cfg.enable {
    services.network-manager-applet.enable = true;
  };
}
