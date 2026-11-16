{ ... }: {
  programs.plasma = {
    enable = true;
    hotkeys.commands = {
      launch-brave = {
        name = "Launch Brave";
        key = "Meta+Shift+B";
        command = "brave";
      };
    };
  };
}
