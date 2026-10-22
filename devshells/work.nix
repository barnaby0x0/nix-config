{
  self,
  pkgs,
  system,
  inputs,
}:

let
  # NIXDOT_WORK_CONFIG="$HOME/.config/nix-config/work-user.nix" nix develop .#work --impure
  userConfigPath = builtins.getEnv "NIXDOT_WORK_CONFIG";

  userConfig =
    if userConfigPath != "" then
      import (builtins.toPath userConfigPath)
    else
      import ./work-user-default.nix;

  terraform-bin = self.packages.${system}.terraform;
  custom-vim = self.packages.${system}.vim;

  hm-files =
    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        self.homeModules.default
        {
          home.username = userConfig.username;
          home.homeDirectory = userConfig.homeDirectory;
          home.stateVersion = "26.05";

          my.user.git = userConfig.git;
        }
      ];
    }).config.home-files;

in
pkgs.mkShell {
  packages = with pkgs; [
    custom-vim
    zsh
    oh-my-zsh
    terraform-bin
    qrencode
    srm
    cowsay
    lolcat
    awscli2
    fortune
    bat
  ];

  shellHook = ''
    export ZDOTDIR="$HOME/hm-files"
    mkdir -p "$ZDOTDIR"

    if [ ! -f "$ZDOTDIR/.zshrc" ] || [ "${hm-files}/.zshrc" -nt "$ZDOTDIR/.zshrc" ]; then
      echo "Syncing Home Manager configuration files..."
      cp -rL "${hm-files}/." "$ZDOTDIR/"
      chmod -R u+w "$ZDOTDIR"
    fi

    export AWS_CA_BUNDLE="/usr/local/share/ca-certificates/root_ca.crt"

    if [ -z "$ZSH_VERSION" ]; then
      fortune | cowsay | lolcat
      exec zsh
    fi
  '';
}
