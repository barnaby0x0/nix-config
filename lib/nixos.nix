{
  nixpkgs,
  unfree,
}:

{
  mkHost =
    {
      system,
      modules,
      specialArgs ? { },
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = modules ++ [
        { nixpkgs.config.allowUnfreePredicate = unfree.predicate; }
      ];

      specialArgs = {
        inherit nixpkgs;
      }
      // specialArgs;

      # specialArgs = {
      #   inherit nixpkgs;
      # }
      # // specialArgs;
    };
}
