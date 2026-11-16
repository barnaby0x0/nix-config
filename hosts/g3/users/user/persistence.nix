{ ... }:

{
  home.persistence."/nix/persist" = {
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
    ];
  };
}
