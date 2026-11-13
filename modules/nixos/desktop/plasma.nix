{ ... }:

{
  hardware.graphics.enable = true;

  services = {
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;

    xserver.xkb = {
      layout = "fr";
      variant = "azerty";
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

  };

  security.rtkit.enable = true;
}
