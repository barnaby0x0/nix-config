# lib/commons/unfree.nix
lib: allowed: {
  predicate = pkg: builtins.elem (lib.getName pkg) allowed;
}
