{
  nixpkgs,
  home-manager,
  mkPkgs,
}:

let
  userConfig = import ./user-config.nix { inherit nixpkgs; };
  mkHomeConfiguration = import ./configuration.nix {
    inherit home-manager;
    inherit mkPkgs;
  };
  resolveHomeImports = import ./imports.nix { inherit nixpkgs; };

in
{
  inherit mkHomeConfiguration resolveHomeImports;

  inherit (userConfig)
    defaultUserConfig
    loadUserConfig
    ;
}
