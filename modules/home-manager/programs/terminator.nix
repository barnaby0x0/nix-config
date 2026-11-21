{ config, lib, pkgs, ... }:

let
  cfg = config.my.programs.terminator;

  terminatorConfig = (pkgs.formats.ini { }).generate "terminator-config" {
    global_config = {
      borderless = true;
    };

    keybindings = {
      broadcast_off = "<Alt>o";
      broadcast_group = "<Alt>g";
      broadcast_all = "<Alt>a";
    };

    profiles.default = {
      use_system_font = false;
      font = "Hack 11";
      background_color = "#300a24";
      background_darkness = 0.96;
      background_type = "transparent";
      foreground_color = "#ffffff";
      show_titlebar = false;
      scrollbar_position = "hidden";
    };
  };

  installTerminatorConfig = pkgs.writeShellScript "install-terminator-config" ''
    mkdir -p "$HOME/.config/terminator"
    cp ${terminatorConfig} "$HOME/.config/terminator/config"
    chmod 644 "$HOME/.config/terminator/config"
  '';

in
{
  options.my.programs.terminator.enable =
    lib.mkEnableOption "Terminator";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.terminator ];

    home.activation.installTerminatorConfig =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${installTerminatorConfig}
      '';
  };
}