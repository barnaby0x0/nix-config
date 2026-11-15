# hosts/k8/users.nix
{ self }:
{
  user = {
    enableVirt = true;
    homeManager = false;
    home.stateVersion = "26.05";

    # Même si homeManager est désactivé ici, on prépare le module
    # pour pouvoir l'activer plus tard sans retoucher la structure.
    homeModule =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          self.homeModules.profiles.base
          self.homeModules.profiles.desktop
        ];

        my.user.git = {
          name = "Victor";
          email = "victor@mail.net";
        };

        home.persistence."/nix/persist" = {
          directories = [ ];
          files = [ ];
        };
      };
  };
}
