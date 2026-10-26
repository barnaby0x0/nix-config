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
      ];
      files = [
        ".p10k.zsh"
      ];
    };
  };
}
