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

    home.packages = with pkgs; [ btop ];

    xdg.configFile."bashtop/bashtop.cfg".text = ''
      color_theme="Default"
      update_ms="2200"
      proc_sorting="cpu lazy"
      proc_reversed="false"
      proc_tree="false"
      check_temp="false"
      draw_clock="%X"
      background_update="true"
      custom_cpu_name=""
      error_logging="true"
      proc_gradient="true"
      proc_per_core="false"
      disks_filter=""
      update_check="false"
      hires_graphs="false"
      use_psutil="false"
    '';

    home.file.".terraformrc".text = ''
      plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
      plugin_cache_may_break_dependency_lock_file = true

      provider_installation {
        dev_overrides {
          "victor/yamlutils" = "$HOME/go/bin"
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
