{
  inputs,
  self,
  users,
  ...
}:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {
    inherit users;
  };

  home-manager.users = inputs.nixpkgs.lib.mapAttrs (_: user: {
    imports = [
      self.homeModules.default
    ];

    home.stateVersion = "26.05";
    my.user.git = user.git;

    home.persistence."/nix/persist" = {
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
  }) (inputs.nixpkgs.lib.filterAttrs (_: user: user.homeManager) users);
}
