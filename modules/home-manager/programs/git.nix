{ config, lib, ... }:

let
  cfg = config.my.programs.git;
in

{

  options.my.programs.git.enable = lib.mkEnableOption "Git";

  options.my.user.git = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Git user name.";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Git user email.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = config.my.user.git.name;
          email = config.my.user.git.email;
        };

        status.showUntrackedFiles = "yes";
      };
    };
  };
}
