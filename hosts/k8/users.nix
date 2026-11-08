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
        "Documents"
        ".local/share/Steam"
        ".steam"
        "Bureau"
        "Downloads"
        "Pictures"
        "Téléchargements"
        "Videos"
        "Workspace"
        {
          directory = ".zsh";
          mode = "0700";
        }
      ];
      files = [
        ".p10k.zsh"
      ];
    };
  };
}
