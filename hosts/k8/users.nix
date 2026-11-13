{
  user = {
    enableVirt = true;
    homeManager = false;
    home.stateVersion = "26.05";

    imports = [
      "homeModules.profiles.base"
      "homeModules.profiles.desktop"
    ];

    git = {
      name = "Victor";
      email = "victor@mail.net";
    };

    persistence = {
      directories = [ ];
      files = [ ];
    };
    # packages = [ "btop" ];

    # home.file.".config/bashtop.cfg".source = ./files/bashtop;
  };
}
