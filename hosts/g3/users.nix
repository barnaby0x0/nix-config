{
  user = {
    enableVirt = true;
    homeManager = true;
    home.stateVersion = "26.05";

    imports = [
      "homeModules.profiles.base"
      # "homeModules.profiles.g3"
    ];

    git = {
      name = "Victor";
      email = "victor@mail.net";
    };

    programs = {
      brave.enable = true;
      firefox.enable = true;
    };

    persistence = {
      directories = [
        "Téléchargements"
        "Bureau"
        ".local"
        ".config"
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
