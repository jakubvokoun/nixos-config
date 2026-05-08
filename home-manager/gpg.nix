{ inputs, lib, config, pkgs, ... }: {
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 300;
    maxCacheTtl = 999999;
    pinentry.package = pkgs.pinentry-curses; # terminal
    # pinentry.package = pkgs.pinentry-gnome3; # if you want GUI popup
  };
}
