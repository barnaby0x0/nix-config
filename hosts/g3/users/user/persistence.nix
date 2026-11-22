{ ... }:

{
  home.persistence."/nix/persist" = {
    directories = [
      "Téléchargements"
      "Bureau"
      "Documents"
      "Videos"
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
