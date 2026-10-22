{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) forAllSystems;
  mkVim = lib.vim.mkVim;
in
forAllSystems (system: {
  vim = mkVim {
    inherit system;
  };
})
