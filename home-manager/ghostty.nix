{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      font-family = "JetBrainsMono Nerd Font";
      font-feature = [
        "-dlig"
        "-liga"
        "-calt"
      ];
      freetype-load-flags = [
        "hinting"
        "no-force-autohint"
        "autohint"
        "no-light"
      ];
      bold-is-bright = true;
      copy-on-select = "clipboard";
      alpha-blending = "native";
      theme = "iTerm2 Tango Dark";
      window-theme = "light";
      window-decoration = "server";
      window-padding-x = [
        5
        5
      ];
      window-padding-y = [
        5
        5
      ];
      term = "xterm-256color";
    };
  };
}
