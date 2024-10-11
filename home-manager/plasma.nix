{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    pkgs.libsForQt5.kompare
    pkgs.libsForQt5.yakuake
    pkgs.libsForQt5.ksshaskpass
    pkgs.libsForQt5.akonadi
    pkgs.libsForQt5.kdepim-runtime
    pkgs.libsForQt5.korganizer
    pkgs.libsForQt5.kate
    pkgs.libsForQt5.kwrited
    pkgs.libsForQt5.kdevelop
    pkgs.libsForQt5.kdev-php
    pkgs.libsForQt5.kdev-python
    pkgs.libsForQt5.keditbookmarks
    pkgs.libsForQt5.kcolorchooser
    pkgs.libsForQt5.skanlite

    pkgs.krusader
    pkgs.krename
  ];
}
