{ inputs, lib, config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
        };
      };
    };
    extraPackages =
      [ pkgs.gopls pkgs.marksman pkgs.bash-language-server pkgs.terraform-ls ];
  };
}
