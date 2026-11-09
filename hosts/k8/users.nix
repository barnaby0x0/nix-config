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
        ".config"
        ".dotfiles"
        ".hist"
        ".local"
        ".local/state/nix-config"
        ".password-store"
        ".secret"
        ".steam"
        "Bureau"
        "Documents"
        "Downloads"
        "Pictures"
        "Téléchargements"
        "Videos"
        "Workspace"
        "TEST"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }

        {
          directory = ".zsh";
          mode = "0700";
        }
      ];
      files = [
        ".p10k.zsh"
        ".bash_history"
        ".gitconfig"
      ];
    };
    packages = [ "btop" ];

    xdgConfigFiles = {
      "bashtop/bashtop.cfg".text = ''
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
    };

    homeFiles = {
      ".terraformrc".text = ''
        plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
        plugin_cache_may_break_dependency_lock_file = true

        provider_installation {
          dev_overrides {
            "victor/yamlutils" = "$HOME/go/bin"
          }

          direct {}
        }
      '';
    };

  };
}
