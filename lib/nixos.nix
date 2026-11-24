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
      nixpkgsInput ? nixpkgs,
    }:
    nixpkgsInput.lib.nixosSystem {
      inherit system;

      modules = modules ++ [
        { nixpkgs.config.allowUnfreePredicate = unfree.predicate; }
      ];

      specialArgs = {
        nixpkgs = nixpkgsInput;
      }
      // specialArgs;
    };
}
