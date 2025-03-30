{ inputs, lib, config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = { theme = "catppuccin_mocha"; };
    extraPackages = [ pkgs.gopls pkgs.marksman ];
  };
}
