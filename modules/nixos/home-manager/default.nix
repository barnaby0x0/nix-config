{
  inputs,
  self,
  users,
  lib,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit self inputs;
    };

    users = lib.mapAttrs (_: user: {
      # Conservé pour compatibilité (username, stateVersion, anciens champs)
      _module.args.userConfig = user;

      imports = [
        self.homeModules.users
      ]
      # Vrai module HM fourni par le host (recommandé)
      ++ lib.optional (user ? homeModule) user.homeModule
      # Ancien mécanisme par chaînes "homeModules.profiles.xxx"
      ++ self.lib.homeManager.resolveHomeImports self (user.imports or [ ]);
    }) (lib.filterAttrs (_: user: user.homeManager or false) users);
  };
}
