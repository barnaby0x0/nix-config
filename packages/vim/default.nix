# packages/vim/default.nix
{
  self,
  inputs,
  lib,
}:
let
  inherit (lib.commons) mkPkgs;
  inherit (lib.commons.system) forAllSystems;
in
forAllSystems (system: {
  vim = lib.vim.mkVim (mkPkgs system);
})
