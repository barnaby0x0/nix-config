{
  home-manager,
  mkPkgs,
}:

{
  system,
  modules,
  specialArgs ? { },
  userConfig ? { },
  pkgs ? mkPkgs system,
  homeManagerInput ? home-manager,
}:

homeManagerInput.lib.homeManagerConfiguration {
  inherit pkgs modules;
  extraSpecialArgs = specialArgs // {
    inherit userConfig;
  };
}
