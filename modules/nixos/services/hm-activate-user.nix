{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.services.hm-activate-user;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  usersWithHomeManager = lib.filterAttrs (_: user: user.enable) cfg.users;
in
{
  options.my.services.hm-activate-user = {
    enable = mkEnableOption "Home Manager standalone activation service";

    users = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.enable = mkEnableOption "Home Manager activation for this user";
        }
      );

      default = { };
      description = "Users for which Home Manager should be activated at boot.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = lib.mapAttrs' (username: _: {
      name = "hm-activate-${username}";

      value = {
        description = "Activate Home Manager configuration for ${username}";

        wantedBy = [ "multi-user.target" ];
        before = [ "display-manager.service" ];

        unitConfig.RequiresMountsFor = [
          config.users.users.${username}.home
        ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;

          User = username;

          Environment = [
            "HOME=${config.users.users.${username}.home}"
            "PATH=${
              lib.makeBinPath [
                pkgs.nix
                pkgs.coreutils
              ]
            }:/run/current-system/sw/bin"
          ];

          ExecStart = "${
            config.users.users.${username}.home
          }/.local/state/home-manager/gcroots/current-home/activate";
        };
      };
    }) usersWithHomeManager;
  };
}
