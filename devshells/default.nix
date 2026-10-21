{
  self,
  pkgs,
  system,
}:
{
  home-manager = import ./home-manager {
    inherit self pkgs system;
  };
  
  devops = import ./devops {
    inherit pkgs;
  };
}