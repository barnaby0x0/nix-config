{ ... }:

{
  home.persistence."/nix/persist" = {
    directories = [
      "Téléchargements"
      "Bureau"
      "Documents"
      ".local"
      ".config"
      ".wallpapers"
      ".var/app"
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
