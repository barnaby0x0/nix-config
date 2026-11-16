{ ... }:

{

  services.flatpak = {
    enable = true;

    packages = [
      "com.brave.Browser"
      "com.github.qarmin.czkawka"
      "com.github.tchx84.Flatseal"
      "com.google.Chrome"
      "com.obsproject.Studio"
      "fr.free.Homebank"
      "im.riot.Riot"
      "io.github.flattool.Warehouse"
      "io.gitlab.librewolf-community"
      "io.mpv.Mpv"
      "md.obsidian.Obsidian"
      "net.sourceforge.mcomix"
      "org.electrum.electrum"
      "org.gnome.Calculator"
      "org.gnome.meld"
      "org.kde.kleopatra"
      "org.kde.okular"
      "org.kde.yakuake"
      "org.keepassxc.KeePassXC"
      "org.sqlitebrowser.sqlitebrowser"
    ];
  };
}
