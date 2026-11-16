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
          ./user/flatpak.nix
          ./user/noctalia.nix
          ./user/persistence.nix
          ./user/plasma.nix
          self.homeModules.nix-flatpak
          self.homeModules.plasma
          self.homeModules.profiles.niri
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

      };
  };
}
