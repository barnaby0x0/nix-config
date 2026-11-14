{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.swayidle;
in
{
  options.my.programs.swayidle = {
    enable = lib.mkEnableOption "swayidle (veille et verrouillage automatiques)";
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      extraArgs = [ "-w" ];

      systemdTargets = [ "niri.service" ];

      events = {
        "before-sleep" = "${pkgs.swaylock}/bin/swaylock -f";
      };

      timeouts = [
        {
          timeout = 180;
          command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          timeout = 480;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
