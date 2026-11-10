{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.firefox;

  extensions = {
    # Dark Reader
    "addon@darkreader.org" = "darkreader";

    # Firefox Multi-Account Containers
    "@testpilot-containers" = "multi-account-containers";

    # FoxyTab
    "foxytab@eros.man" = "foxytab";

    # Link Gopher
    "[email protected]" = "link-gopher";

    # KDE Plasma Integration
    "plasma-browser-integration@kde.org" = "plasma-integration";

    # Tab Reloader
    "jid0-bnmfwWw2w2w4e4edvcdDbnMhdVg@jetpack" = "tab-reloader";

    # Tab Stash
    "tab-stash@condordes.net" = "tab-stash";

    # uBlock Origin
    "uBlock0@raymondhill.net" = "ublock-origin";

    # Web Archives
    "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = "view-page-archive";

    # xBrowserSync
    "{019b606a-6f61-4d01-af2a-cea528f606da}" = "xbs";
  };

  extensionSettings = builtins.mapAttrs (id: slug: {
    installation_mode = "force_installed";
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  }) extensions;
in
{
  options.my.programs.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          # Disk cache
          "browser.cache.disk.enable" = true;
          "browser.cache.disk.parent_directory" = "/tmp/firefox/cache";

          # Memory cache
          "browser.cache.memory.enable" = true;
        };
      };

      policies.ExtensionSettings = extensionSettings;
    };
  };
}
