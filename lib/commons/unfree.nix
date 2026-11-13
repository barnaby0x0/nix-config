lib:
let
  allowed = [ "vim-yaml" "veracrypt" ];
in
{
  inherit allowed;
  predicate = pkg: builtins.elem (lib.getName pkg) allowed;
}