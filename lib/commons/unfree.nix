# lib/commons/unfree.nix
lib: {
  allowed = [ "vim-yaml" "veracrypt" ];
  predicate = pkg: builtins.elem (lib.getName pkg) allowed;
}