{ ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/nix/persist/home/user" = {
    directories = [
      ".config"
      "Downloads"
      ".local/share/Steam"
      ".steam"
      ".local/state"
    ];

    files = [
      ".zsh_history"
      ".p10k.zsh"
    ];
  };
}
