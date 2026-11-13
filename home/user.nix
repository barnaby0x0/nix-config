{ vim-flake, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "26.05";
  };

  imports = [
    ./profiles/user
  ];
}
