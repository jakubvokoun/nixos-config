{ inputs, lib, config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = { theme = "catppuccin_mocha"; };
    extraPackages = [ pkgs.gopls pkgs.marksman pkgs.bash-language-server pkgs.terraform-ls ];
  };
}
