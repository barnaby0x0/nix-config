{
  nixpkgs,
  home-manager,
}:

let
  mkPkgs = import ./pkgs.nix {
    inherit nixpkgs;
  };

  userConfig = import ./user-config.nix {
    inherit nixpkgs;
  };

  mkHomeConfiguration = import ./configuration.nix {
    inherit home-manager mkPkgs;
  };

  resolveHomeImports = import ./imports.nix {
    inherit nixpkgs;
  };

in
{
  inherit mkPkgs mkHomeConfiguration resolveHomeImports;

  inherit (userConfig)
    defaultUserConfig
    loadUserConfig
    ;
}
