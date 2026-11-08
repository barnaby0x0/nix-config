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
        "Téléchargements"
        "Bureau"
        ".local/share/Steam"
        ".steam"
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
  };
}
