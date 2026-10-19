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
in
{
  inherit mkPkgs mkHomeConfiguration;

  inherit (userConfig)
    defaultUserConfig
    loadUserConfig
    ;
}
