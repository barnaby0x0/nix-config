{ ... }:

{
  programs.noctalia = {
    enable = true;

    settings = {
      bar.default = {
        position = "bottom";
        auto_hide = false;
        margin_ends = 0; # pleine largeur
        margin_edge = 0; # collée au bord
        radius = 0; # coins carrés

        start = [
          "launcher"
          "wallpaper"
          "workspaces"
        ];
        center = [ "clock" ];
        # end = [
        #   "media"
        #   "tray"
        #   "notifications"
        #   "clipboard"
        #   "network"
        #   "bluetooth"
        #   "volume"
        #   "brightness"
        #   "battery"
        #   # "control-center"
        #   "session"
        # ];

        end = [
          "audio-vis"
          "cpu"
          "ram"
          "temperature"
          "media"
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "power_profile"
          "battery"
          # "control-center"
          "session"
        ];

      };

      widget = {
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "gauge";
          show_value = true;
        };

        ram = {
          type = "sysmon";
          stat = "ram_used";
          visualization = "gauge";
          show_value = true;
        };

        temperature = {
          type = "sysmon";
          stat = "cpu_temp";
          visualization = "none";
          show_value = true;
        };

        audio-vis = {
          type = "audio_visualizer";
          width = 104;
          # width = 64;
          bands = 20;
          centered = true;
          show_when_idle = false;
          color_1 = "primary";
          color_2 = "secondary";
        };

        media = {
          hide_when_no_media = true;
          hide_when_idle = false;
          max_length = 220;
          title_scroll = "on_hover";
        };
      };

      plugins = {
        # Fully-qualified ids ("<author>/<plugin>") that are active.
        enabled = [ "noctalia/screen_recorder" "noctalia/wallhaven" ];
        auto_update = "all"; # "all" | "official" | "none"; background git updates on startup and every 6 hours

        source = [
          {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            enabled = true;
          }

          # # Source "my-dev" (Chemin local)
          # {
          #   name = "my-dev";
          #   kind = "path";
          #   location = "~/dev/my-plugins"; # Ou un chemin absolu comme "/home/votre-user/dev/my-plugins"
          #   enabled = true;
          # }
        ];
      };

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        # templates = {
        #   enable_builtin_templates = true;
        #   builtin_ids = [ "niri" ];
        # };

      };

      wallpaper = {
        directory = "/home/user/.wallpapers";
        automation = {
          enabled = false;
          interval_seconds = 1800;
          order = "random";
          pause_on_fullscreen = false;
          recursive = true;
        };
      };

      nightlight = {
        enabled = true;
        force = false;

        temperature_day = 6500;
        temperature_night = 4000;
      };

      weather = {
        enabled = true;
        refresh_minutes = 30;
        unit = "metric";
        effects = true;
      };

      location = {
        auto_locate = false;
        address = "Lausanne";
        # latitude = "46,5185";
        # longitude = "6,6385";
      };

      system.monitor = {
        enabled = true; # sample CPU, memory, network, load, temperature, GPU VRAM, and disk statistics
        cpu_temp_sensor_path = ""; # exact temp*_input path for CPU temperature override; empty = auto
        cpu_poll_seconds = 2.0; # CPU usage, frequency, temperature, and load average
        gpu_poll_seconds = 5.0; # GPU temperature, usage, and VRAM; probes run only while displayed
        memory_poll_seconds = 2.0; # RAM usage
        network_poll_seconds = 3.0; # network throughput
        disk_poll_seconds = 10.0; # disk usage and swap usage
      };

      shell.session = {
        grid = false;
        grid_columns = 3;
        actions = [
          {
            action = "lock";
            enabled = true;
            shortcut = "v";
          }
          {
            action = "suspend";
            enabled = true;
            shortcut = "s";
          }
          {
            action = "logout";
            enabled = true;
            shortcut = "d";
          }
          {
            action = "reboot";
            enabled = true;
            shortcut = "r";
          }
          {
            action = "shutdown";
            enabled = true;
            shortcut = "e";
          }
        ];
      };

    };
  };
}
