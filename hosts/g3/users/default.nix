# hosts/g3/users.nix
{ self }:
{
  user = {
    enableVirt = true;
    homeManager = true;
    home.stateVersion = "26.05";

    # HM Module
    homeModule =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          self.homeModules.profiles.niri
          ./user/noctalia.nix
          ./user/plasma.nix
          ./user/persistence.nix
        ];

        my.user.git = {
          name = "Victor";
          email = "victor@mail.net";
        };

        my.programs = {
          brave.enable = true;
          firefox.enable = true;
          zsh.enable = true;
          terminator.enable = true;
          vim.enable = true;
        };

        # Taille du curseur (méthode qui fonctionne)
        home.pointerCursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };

        # Et éventuellement
        # dconf.settings."org/gnome/desktop/interface" = {
        #   cursor-theme = "Adwaita";
        #   cursor-size = 24;
        # };

        # programs.noctalia = {
        #   enable = true;

        #   settings = {
        #     theme.mode = "dark";
        #     bar.default = {
        #       position = "bottom";
        #       auto_hide = false;
        #       margin_ends = 0; # pleine largeur
        #       margin_edge = 0; # collée au bord
        #       radius = 0; # coins carrés
        #     };

        #     wallpaper = {
        #       directory = "/home/user/.wallpapers";
        #       automation = {
        #         enabled = false;
        #         interval_seconds = 1800;
        #         order = "random";
        #         pause_on_fullscreen = false;
        #         recursive = true;
        #       };
        #     };
        #   };
        # };

        # home.persistence."/nix/persist" = {
        #   directories = [
        #     "Téléchargements"
        #     "Bureau"
        #     ".local"
        #     ".config"
        #     ".wallpapers"
        #     {
        #       directory = ".zsh";
        #       mode = "0700";
        #     }
        #   ];
        #   files = [
        #     ".p10k.zsh"
        #   ];
        # };
      };
  };
}
