{
  home-manager,
  mkPkgs,
}:

{
  system,
  modules,
  specialArgs ? { },
  userConfig ? { },
}:

home-manager.lib.homeManagerConfiguration {
  pkgs = mkPkgs system;
  inherit modules;

  extraSpecialArgs = specialArgs // {
    inherit userConfig;
  };
}
