{
  inputs,
  self,
  users,
  lib,
  ...
}:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {
    inherit self inputs;
  };

  home-manager.users = lib.mapAttrs (_: user: {
    _module.args.userConfig = user;

    imports = [
      self.homeModules.users
    ]
    ++ self.lib.homeManager.resolveHomeImports self (user.imports or [ ]);
    # ++ map (
    #   imp:
    #   lib.attrByPath (lib.splitString "." imp) (throw "Import Home Manager introuvable : ${imp}") self
    # ) (user.imports or [ ]);
  }) (lib.filterAttrs (_: user: user.homeManager or false) users);
}
