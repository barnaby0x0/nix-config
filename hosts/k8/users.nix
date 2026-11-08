{
  user = {
    enableVirt = true;
    homeManager = true;

    git = {
      name = "Victor";
      email = "victor@mail.net";
    };

    persistence = {
      directories = [
        ".config"
        ".dotfiles"
        ".hist"
        ".local"
        ".local/state/nix-config"
        ".password-store"
        ".secret"
        ".steam"
        "Bureau"
        "Documents"
        "Downloads"
        "Pictures"
        "Téléchargements"
        "Videos"
        "Workspace"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }

        {
          directory = ".zsh";
          mode = "0700";
        }
      ];
      files = [
        ".p10k.zsh"
        ".bash_history"
        ".gitconfig"
      ];
    };
  };
}
