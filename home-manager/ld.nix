{ inputs, lib, config, pkgs, ... }: {
  # Linux Days & InastallFest

  # Overriding themes
  programs.helix.settings.theme = lib.mkForce "catppuccin_latte";
  programs.zellij.settings.theme = lib.mkForce "catppuccin-latte";
  programs.kitty.themeFile = lib.mkForce "Catppuccin-Latte";
  programs.nixvim.colorschemes = lib.mkForce {
    tokyonight.enable = false;
    catppuccin = {
      enable = true;
      settings = { flavour = "latte"; };
    };
  };
}
