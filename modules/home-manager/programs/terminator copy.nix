{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.terminator;
in

{
  options.my.programs.terminator.enable = lib.mkEnableOption "Terminator";

  config = lib.mkIf cfg.enable {

programs.terminator = {
  enable = true;

  config = {
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
};


    # programs.terminator = {
    #   enable = true;

    #   config = {
    #     global_config = {
    #       borderless = true;
    #     };

    #     keybindings = {
    #       broadcast_off = "<Alt>o";
    #       broadcast_group = "<Alt>g";
    #       broadcast_all = "<Alt>a";
    #     };

    #     profiles.default = {
    #       use_system_font = false;
    #       font = "Hack 11";
    #       background_color = "#300a24";
    #       background_darkness = 0.96;
    #       background_type = "transparent";
    #       foreground_color = "#ffffff";
    #       show_titlebar = false;
    #       scrollbar_position = "hidden";
    #     };

    #     layouts.default = {
    #       window0 = {
    #         type = "Window";
    #         parent = "";
    #         size = "900, 400";
    #       };

    #       child1 = {
    #         type = "Terminal";
    #         parent = "window0";
    #       };
    #     };
    #   };
    # };

    # home.packages = with pkgs; [
    #   terminator
    # ];

    # home.file.".config/terminator/config".text = ''
    #   [global_config]
    #     borderless = True

    #   [keybindings]
    #     broadcast_off = <Alt>o
    #     broadcast_group = <Alt>g
    #     broadcast_all = <Alt>a

    #   [profiles]
    #     [[default]]
    #       use_system_font = False
    #       font = Hack 11
    #       background_color = "#300a24"
    #       background_darkness = 0.96
    #       background_type = transparent
    #       foreground_color = "#ffffff"
    #       show_titlebar = False
    #       scrollbar_position = hidden

    #   [layouts]
    #     [[default]]
    #       [[[window0]]]
    #         type = Window
    #         parent = ""
    #         size = 900, 400
    #       [[[child1]]]
    #         type = Terminal
    #         parent = window0

    #   [plugins]
    # '';
  };
}
