{
  pkgs,
  ...
}:

{

  programs = {
    steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];

      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
    };

    gamemode.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    steam-run
    vulkan-tools
    mesa-demos
    goverlay
    vkbasalt
    wine
    winetricks
    # lutris brake cause of gtk+-2.24.33
    heroic
  ];

  environment.variables = {
    MANGOHUD = "1";
  };
}
