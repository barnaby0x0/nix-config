{pkgs}:
pkgs.mkShell {
      packages = with pkgs; [
        nodejs
        git
        python3
      ];
      shellHook = ''
        echo "Environnement Nix Ready"
      '';
}
