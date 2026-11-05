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
      self.homeModules.args
      self.homeModules.options.git
      self.homeModules.programs.git
      self.homeModules.programs.vim
      self.homeModules.programs.shell
      self.homeModules.profiles.desktop
    ];

    home.stateVersion = "26.05";
    my.user.git = user.git;

    home.persistence."/nix/persist" = {
      directories = user.persistence.directories;
      files = user.persistence.files;
    };

  }) (inputs.nixpkgs.lib.filterAttrs (_: user: user.homeManager) users);
}
