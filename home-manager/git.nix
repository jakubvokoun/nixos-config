{ inputs, lib, config, pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jakub Vokoun";
        email = "jakub.vokoun@gmail.com";
      };
    };
    lfs = { enable = true; };
  };

  home.packages = [ pkgs.git-filter-repo ];
}
