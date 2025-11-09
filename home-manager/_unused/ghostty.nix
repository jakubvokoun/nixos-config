{ inputs, lib, config, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      font-family = "JetBrainsMono Nerd Font";
      font-thicken = true;
      font-feature = [ "-dlig" "-liga" "-calt" ];
      theme = "iTerm2 Tango Dark";
      window-decoration = "server";
    };
  };
}
