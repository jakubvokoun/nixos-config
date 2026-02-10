{ inputs, lib, config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        soft-wrap = { enable = true; };
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
    extraPackages = [
      pkgs.gopls
      pkgs.marksman
      pkgs.bash-language-server
      pkgs.terraform-ls
      pkgs.nixd
      (pkgs.callPackage
        "${config.home.homeDirectory}/.config/home-manager/packages/ansible-language-server"
        { })
    ];
  };
}
