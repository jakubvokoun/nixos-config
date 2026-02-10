{ inputs, lib, config, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      font-family = "JetBrainsMono Nerd Font";
      font-feature = [ "-dlig" "-liga" "-calt" ];
      freetype-load-flags = [ "force-autohint" "hinting" "autohint" ];
      bold-is-bright = true;
      theme = "iTerm2 Tango Dark";
      window-theme = "light";
      window-decoration = "server";
      window-padding-x = [ 0 0 ];
      window-padding-y = [ 0 0 ];
    };
  };
}
