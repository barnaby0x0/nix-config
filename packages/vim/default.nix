# {
#   self,
#   inputs,
#   lib,
# }:

# let
#   inherit (lib.homeManager) mkPkgs;
#   inherit (lib.commons.system) forAllSystems;
#   mkVim = lib.vim.mkVim;
# in
# forAllSystems (system: {
#   vim = mkVim {
#     inherit system;
#   };
# })


# packages/vim/default.nix  (comme terraform/packer/vault)
{ self, inputs, lib }:
let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) forAllSystems;
in
forAllSystems (system: {
  vim = lib.vim.mkVim (mkPkgs system);
})