{
  nixpkgs,
}:

{
  mkHost =
    {
      system,
      modules,
      specialArgs ? { },
    }:
    nixpkgs.lib.nixosSystem {
      inherit system modules;

      specialArgs = {
        inherit nixpkgs;
      }
      // specialArgs;
    };
}
