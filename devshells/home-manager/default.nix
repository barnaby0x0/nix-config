{
  self,
  pkgs,
  system,
}:
pkgs.mkShell {
      packages = [
        self.packages.${system}.nixdot
      ];
    }
