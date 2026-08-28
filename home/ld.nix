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
  programs.helix.settings.theme = lib.mkForce "catppuccin_latte";
  programs.ghostty.settings.theme = lib.mkForce "iTerm2 Tango Light";
  programs.nixvim.colorschemes.catppuccin.settings.flavour = lib.mkForce "latte";
}
