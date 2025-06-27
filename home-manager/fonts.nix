{ inputs, lib, config, pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.corefonts
    pkgs.font-awesome
    pkgs.jetbrains-mono
    pkgs.powerline-fonts
    pkgs.powerline-symbols
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.noto-fonts
    pkgs.corefonts
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.ubuntu
    pkgs.nerd-fonts.ubuntu-sans
    pkgs.nerd-fonts.ubuntu-mono
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.go-mono
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.liberation
    pkgs.nerd-fonts.roboto-mono
    pkgs.nerd-fonts.inconsolata
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.caskaydia-mono
    pkgs.nerd-fonts.caskaydia-cove
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.dejavu_fonts
  ];
}
