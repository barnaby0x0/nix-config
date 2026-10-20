{
  self,
  inputs,
  lib,
}:

import ./home-manager {
  inherit self inputs lib;
}
