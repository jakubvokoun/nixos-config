{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # Linux Days & InastallFest

  # Overriding themes
  programs.helix.settings.theme = lib.mkForce "tokyonight_day";
  programs.ghostty.settings.theme = lib.mkForce "iTerm2 Tango Light";
  programs.nixvim.colorschemes.tokyonight.settings.style = lib.mkForce "day";
}
