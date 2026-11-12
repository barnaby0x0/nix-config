{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.my.settings.ssd.optim;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.my.settings.ssd.optim.enable = mkEnableOption "Home Manager standalone activation service";
  config = mkIf cfg.enable {

    # nix.settings = {
    #     substituters = [
    #       "https://cache.nixos.org/"
    #     ];

    #     trusted-public-keys = [
    #       # Clé officielle correspondante
    #     ];

    #     builders-use-substitutes = true;
    #   };

    services.fstrim = {
      enable = true;
      interval = "weekly";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Don't use for desktop increase io
    # nix.settings.auto-optimise-store = true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 100;
    };

    # boot.tmp.useTmpfs = true;                 # /tmp en RAM : builds Nix et cache Brave (--disk-cache-dir=/tmp/...)
    # boot.tmp.tmpfsSize = "50%";               # les gros builds ont besoin de place
    # services.fstrim.enable = true;            # TRIM hebdomadaire (sur Arch : systemctl enable fstrim.timer)
    # zramSwap.enable = true;                   # swap compressé en RAM plutôt que sur disque
    # services.journald.extraConfig = "SystemMaxUse=500M";

  };
}
