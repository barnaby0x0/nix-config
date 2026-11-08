{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkHomeConfiguration loadUserConfig;
  inherit (lib.commons.system) systems;
  inherit (lib.vim) mkVim;

  mkUserHomeConfiguration =
    {
      host,
      system ? "x86_64-linux",
      username ? "user",
    }:

    let
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
      ];
    };

  genericConfigurations = builtins.listToAttrs (
    map (system: {
      name = "generic-${system}";

      value = mkHomeConfiguration {
        inherit system;

        specialArgs = {
          inherit self;
          inherit mkVim;
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
      inherit mkVim;
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
