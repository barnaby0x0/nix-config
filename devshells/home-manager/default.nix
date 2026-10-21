{
  self,
  pkgs,
  systems,
}:
pkgs.mkShell {
      packages = [
        self.packages.${system}.nixdot
      ];
    }
