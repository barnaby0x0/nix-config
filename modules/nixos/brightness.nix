{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.hardware.brightness;
in
{
  options.my.hardware.brightness = {
    enable = lib.mkEnableOption "brightness control (DDC/CI) for Noctalia + niri";

    username = lib.mkOption {
      type = lib.types.str;
      default = "user";
      description = "User to apply extragroup";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ddcutil
    ];
    hardware.i2c.enable = true;
    users.users.${cfg.username}.extraGroups = [ config.hardware.i2c.group ];
  };
}
