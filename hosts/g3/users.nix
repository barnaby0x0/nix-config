# hosts/g3/users.nix
{
  user = {
    enableVirt = true;
    homeManager = true;
    home.stateVersion = "26.05";

    imports = [
      "homeModules.profiles.niri"
    ];

    git = {
      name = "Victor";
      email = "victor@mail.net";
    };

    myprograms = {
      brave.enable = true;
      firefox.enable = true;
      zsh.enable = true;
      terminator.enable = true;
      vim.enable = true;
    };

    programs = {
      noctalia = {
        enable = true;

        settings = {
          theme.mode = "dark";
          bar.default = {
            position = "bottom";
            auto_hide = false;

            margin_ends = 0; # plus d'espace aux extrémités : pleine largeur
            margin_edge = 0; # collée au bord de l'écran
            radius = 0; # coins carrés
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
        };
      };
    };

    persistence = {
      directories = [
        "Téléchargements"
        "Bureau"
        ".local"
        ".config"
        ".wallpapers"
        {
          directory = ".zsh";
          mode = "0700";
        }
      ];
      files = [
        ".p10k.zsh"
        # ".zsh_history"
      ];
    };
    xdgConfigFiles = { };
    homeFiles = { };
    packages = [ ];
  };
}
