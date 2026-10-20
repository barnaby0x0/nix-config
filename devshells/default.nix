{ self, inputs, lib }:

let
inherit (lib.commons.system) forAllSystems;
in
forAllSystems (system: {
default = import./home-manager {
    inherit self inputs lib;
};
})