{ pkgs }:

{
  mkDevShell =
    {
      name,
      packages ? [ ],
      shellHook ? "",
    }:
    pkgs.mkShell {
      name = name;

      packages =
        with pkgs;
        [
          git
          curl
          jq
        ]
        ++ packages;

      shellHook = ''
        echo "Environnement ${name} prêt"
        ${shellHook}
      '';
    };
}
