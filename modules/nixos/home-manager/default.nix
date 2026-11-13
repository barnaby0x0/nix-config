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
      _module.args.userConfig = user;

      imports = [
        self.homeModules.users
      ]
      ++ self.lib.homeManager.resolveHomeImports self (user.imports or [ ]);
    }) (lib.filterAttrs (_: user: user.homeManager or false) users);
  };
}
