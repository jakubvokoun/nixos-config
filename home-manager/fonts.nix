{ inputs, lib, config, pkgs, ... }: {
  #fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.font-awesome
    pkgs.jetbrains-mono
    pkgs.powerline-fonts
    pkgs.powerline-symbols
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.noto-fonts
    pkgs.corefonts
    pkgs.nerdfonts
    pkgs.dejavu_fonts
    #(pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
