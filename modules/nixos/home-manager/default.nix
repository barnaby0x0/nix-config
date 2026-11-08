# {
#   inputs,
#   self,
#   users,
#   pkgs,
#   lib,
#   ...
# }:

# {
#   home-manager.useGlobalPkgs = true;
#   home-manager.useUserPackages = true;

#   home-manager.extraSpecialArgs = {
#     inherit users;
#   };

#   home-manager.users = inputs.nixpkgs.lib.mapAttrs (_: user: {
#     imports =
#       [ ]
#       ++ (map (
#         imp:
#         inputs.nixpkgs.lib.attrByPath (inputs.nixpkgs.lib.splitString "." imp)
#           (throw "Import Home Manager introuvable : ${imp}")
#           self
#       ) user.imports);

#     home.stateVersion = user.home.stateVersion;
#     my.user.git = user.git;

#     home.packages = (with pkgs; [ ]) ++ (map (package: pkgs.${package}) user.packages);

#     xdg.configFile = user.xdgConfigFiles;

#     home.file = user.homeFiles;

#     home.persistence."/nix/persist" = {
#       directories = user.persistence.directories;
#       files = user.persistence.files;
#     };
#   }) (inputs.nixpkgs.lib.filterAttrs (_: user: user.homeManager) users);
# }

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

# home-manager.users = lib.mapAttrs
#   (_: user: {
#     imports = [
#       self.homeModules.profiles.base
#       self.homeModules.profiles.desktop
#       self.homeModules.args
#     ];

#     home.stateVersion = user.home.stateVersion;
#     my.user.git = user.git;
#   })
#   (lib.filterAttrs
#     (_: user: user.homeManager or false)
#     users
#   );

  home-manager.users = lib.mapAttrs
    (_: user: {
      _module.args.userConfig = user;

      imports = [
        self.homeModules.users
      ];
    })
    (lib.filterAttrs
      (_: user: user.homeManager or false)
      users
    );
}