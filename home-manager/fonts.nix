{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.jetbrains-mono
    pkgs.powerline-fonts
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.noto-fonts
    pkgs.corefonts
    pkgs.nerdfonts
    pkgs.dejavu_fonts
  ];
}
