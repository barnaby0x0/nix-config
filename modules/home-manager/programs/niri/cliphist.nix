{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.cliphist;
in
{
  options.my.programs.cliphist = {
    enable = lib.mkEnableOption "cliphist (historique du presse-papiers)";
  };

  config = lib.mkIf cfg.enable {
    services.cliphist = {
      enable = true;
      # --watch command is not implemented, which breaks the entire purpose of it
      #clipboardPackage = pkgs.wl-clipboard-rs;
      systemdTargets = [ "niri.service" ];
    };
  };
}
