{pkgs}:
pkgs.mkShell {
      packages = [
        nodejs
        git
        python3
      ];
      shellHook = ''
        echo "Environnement Nix Ready"
      '';
}
