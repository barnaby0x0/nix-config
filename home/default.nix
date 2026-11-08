{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkHomeConfiguration loadUserConfig;
  inherit (lib.commons.system) systems;
  inherit (lib.vim) mkVim;

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

  "user@k8" =
    let
      # userConfig = (import ../hosts/k8/users.nix).user;
      userConfig = (import ../hosts/k8/users.nix).user // {
        username = "user";
        homeDirectory = "/home/user";
      };
      pkgsLib = inputs.nixpkgs.lib;
    in
    mkHomeConfiguration {
      system = "x86_64-linux";

      specialArgs = { inherit self inputs; };

      inherit userConfig;

      modules = [
        self.homeModules.users
        "${inputs.impermanence}/home-manager.nix"
        { home._nixosModuleImported = true; }
      ]
      ++ map (
        imp:
        pkgsLib.attrByPath (pkgsLib.splitString "." imp) (throw "Import Home Manager introuvable : ${imp}")
          self
      ) (userConfig.imports or [ ]);
    };
}
// genericConfigurations
