# modules/home-manager/programs/niri.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.niri;
  noctalia = cmd: "noctalia msg ${cmd}";

  azertyDigits = [
    "ampersand"
    "eacute"
    "quotedbl"
    "apostrophe"
    "parenleft"
    "minus"
    "egrave"
    "underscore"
    "ccedilla"
  ];

  azertyWorkspaceBinds = lib.listToAttrs (
    lib.concatLists (
      lib.imap1 (i: key: [
        (lib.nameValuePair "Mod+${key}" { focus-workspace = i; })
        (lib.nameValuePair "Mod+Ctrl+${key}" { move-column-to-workspace = i; })
      ]) azertyDigits
    )
  );

  cyclePowerProfile = pkgs.writeShellScript "cycle-power-profile" ''
        case "$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)" in
          power-saver) next=balanced ;;
          balanced)    next=performance ;;
          *)           next=power-saver ;;
        esac
    ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$next"    
  '';
  # ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$next" \
  #   && ${pkgs.libnotify}/bin/notify-send -t 1500 "Power profile" "$next"
in
{
  options.my.programs.niri = {
    enable = lib.mkEnableOption "niri (compositeur) intégré à Noctalia";

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "terminator";
      description = "Terminal lancé par Mod+Return.";
    };

    layout = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "fr";
      description = "Disposition xkb du clavier. Si null, niri utilise la configuration système.";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;

      # Config par défaut de niri, maintenue en amont. Tout ce qui suit la
      # complète ou la surcharge (niri : les `binds` ultérieurs écrasent les
      # touches en conflit).
      enableDefaultConfig = true;

      settings = {
        # Permet aux notifications de Noctalia d'activer des fenêtres
        debug.honor-xdg-activation-with-invalid-serial = { };

        # cursor = {
        #   # xcursor-theme = "Adwaita";  # optionnel
        #   xcursor-size = 24;
        # };

        binds = {
          "Mod+E" = {
            _props.hotkey-overlay-title = "Fichiers";
            spawn = [ "nautilus" ];
          };
          "Mod+Return".spawn = [ cfg.terminal ];

          # "Mod+B" = {
          #   hotkey-overlay.title = "Cycle power profile";
          #   action.spawn = [ "${cyclePowerProfile}" ];
          # };

          "Mod+B" = {
            _props.hotkey-overlay-title = "Cycle power profile";
            spawn = [ "${cyclePowerProfile}" ];
          };

          "Mod+Alt+Left".set-column-width = "-10%";
          "Mod+Alt+Right".set-column-width = "+10%";

          "Mod+Space".spawn-sh = noctalia "panel-toggle launcher";
          "Mod+S".spawn-sh = noctalia "panel-toggle control-center";
          "Mod+Shift+S".spawn-sh = noctalia "settings-toggle";
          "Mod+Shift+P".spawn-sh = noctalia "panel-toggle session";
          "Mod+Shift+V".spawn-sh = noctalia "panel-toggle clipboard";
          "Print".spawn-sh = noctalia "screenshot-region";
          "Super+Alt+L".spawn-sh = noctalia "screen-lock";

          "XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn-sh = noctalia "volume-up";
          };
          "XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn-sh = noctalia "volume-down";
          };
          "XF86AudioMute" = {
            _props.allow-when-locked = true;
            spawn-sh = noctalia "volume-mute";
          };
          "XF86MonBrightnessUp" = {
            _props.allow-when-locked = true;
            spawn-sh = noctalia "brightness-up";
          };
          "XF86MonBrightnessDown" = {
            _props.allow-when-locked = true;
            spawn-sh = noctalia "brightness-down";
          };

          "Mod+F1".show-hotkey-overlay = { };
        }
        # Workspaces 1 à 9 sur AZERTY : Mod+& é " ' ( - è _ ç (Mod+Ctrl pour envoyer la colonne)
        // lib.optionalAttrs (cfg.layout == "fr") azertyWorkspaceBinds;

        # Nœuds répétés ou paramétrés
        _children = [
          # Noctalia fournit barre, lanceur, notifications, verrouillage, fond d'écran...
          { spawn-at-startup = "noctalia"; }

          # Fenêtre de réglages de Noctalia en flottant
          {
            window-rule._children = [
              { match._props.app-id = "dev.noctalia.Noctalia.Settings"; }
              { open-floating = true; }
              { default-column-width.fixed = 1080; }
              { default-window-height.fixed = 920; }
            ];
          }

          # Fond d'écran flouté dans la vue d'ensemble
          {
            layer-rule._children = [
              { match._props.namespace = "^noctalia-backdrop"; }
              { place-within-backdrop = true; }
            ];
          }
        ]
        ++ lib.optional (cfg.layout != null) {
          input.keyboard.xkb.layout = cfg.layout;
        };
      };
    };
  };
}
