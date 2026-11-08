{
  inputs,
  self,
  users,
  pkgs,
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
      self.homeModules.profiles.base
      self.homeModules.profiles.desktop
    ];

    home.stateVersion = "26.05";
    my.user.git = user.git;

    # home.packages = with pkgs; [];

    home.file.".terraformrc".text = ''
      plugin_cache_dir = "${config.home.homeDirectory}/.terraform.d/plugin-cache"
      plugin_cache_may_break_dependency_lock_file = true

      provider_installation {
        dev_overrides {
          "victor/yamlutils" = "${config.home.homeDirectory}/go/bin"
        }

        direct {}
      }
    '';

    home.persistence."/nix/persist" = {
      directories = user.persistence.directories;
      files = user.persistence.files;
    };
  }) (inputs.nixpkgs.lib.filterAttrs (_: user: user.homeManager) users);
}
