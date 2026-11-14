{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkHomeConfiguration loadUserConfig resolveHomeImports;
  inherit (lib.commons.system) systems;

  mkUserHomeConfiguration =
    {
      host,
      system ? "x86_64-linux",
      username ? "user",
    }:

    let
      pkgsLib = inputs.nixpkgs.lib;

      userConfig = (import ../hosts/${host}/users.nix).${username} // {
        inherit username;
        homeDirectory = "/home/${username}";
      };
    in

    mkHomeConfiguration {
      inherit system userConfig;

      specialArgs = {
        inherit self inputs;
      };

      modules = [
        self.homeModules.users
        "${inputs.impermanence}/home-manager.nix"
        { home._nixosModuleImported = true; }
      ]
      ++ resolveHomeImports self (userConfig.imports or [ ]);
    };

  genericConfigurations = builtins.listToAttrs (
    map (system: {
      name = "generic-${system}";

      value = mkHomeConfiguration {
        inherit system;

        specialArgs = {
          inherit self;
        };

        modules = [
          ./generic.nix
        ];

        userConfig = loadUserConfig;
      };
    }) systems
  );
in
{
  victor-laptop = mkHomeConfiguration {
    system = "x86_64-linux";

    specialArgs = {
      inherit self;
    };

    modules = [
      ./user.nix
    ];
  };
  "user@k8" = mkUserHomeConfiguration {
    host = "k8";
  };

  "user@g3" = mkUserHomeConfiguration {
    host = "g3";
  };

}
// genericConfigurations
