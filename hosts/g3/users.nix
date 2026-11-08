{
  user = {
    enableVirt = true;
    homeManager = true;
    home.stateVersion = "26.05";

    imports = [
      "homeModules.args"
      "homeModules.profiles.base"
      "homeModules.profiles.desktop"
    ];

    git = {
      name = "Victor";
      email = "victor@mail.net";
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
