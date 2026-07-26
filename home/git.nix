{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jakub Vokoun";
        email = "jakub.vokoun@gmail.com";
      };
      push.autoSetupRemote = true;
    };
    lfs = {
      enable = true;
    };
    # Credentials live outside the store — home-manager renders its gitconfig
    # into a world-readable /nix/store path, so tokens must never be declared in
    # Nix. Keep them in ~/.config/git/local (0600, untracked); a missing include
    # file is not an error.
    includes = [ { path = "~/.config/git/local"; } ];
  };

  home.packages = [ pkgs.git-filter-repo ];
}
