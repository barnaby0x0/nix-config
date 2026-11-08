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

  "user@k8" = mkHomeConfiguration {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs self;
      users = import ../hosts/k8/users.nix;
    };

    modules = [
      # ../modules/home-manager
      # ../hosts/k8/home-manager-user.nix
      self.homeModules.profiles.base
      self.homeModules.profiles.desktop
      self.homeModules.args
      ../hosts/k8/users.nix
    ];
  };

}
// genericConfigurations
