# packages/vim/default.nix
{
  self,
  inputs,
  lib,
}:
let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) forAllSystems;
in
forAllSystems (system: {
  vim = lib.vim.mkVim (mkPkgs system);
})
