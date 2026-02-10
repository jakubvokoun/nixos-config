{ inputs, lib, config, pkgs, ... }: {
  # Linux Days

  # Terminal with light backgroud for presenting
  home.packages = with pkgs; [ ptyxis ];

  # Overriding themes
  programs.helix = { settings = { theme = lib.mkForce "tokyonight-day"; }; };
  programs.zellij = { settings = { theme = lib.mkForce "tokyo-night-light"; }; };
}
