{
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
}
