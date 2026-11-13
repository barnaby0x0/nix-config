{ nixpkgs, unfree }:
system:
import nixpkgs {
  inherit system;
  config.allowUnfreePredicate = unfree.predicate;
}