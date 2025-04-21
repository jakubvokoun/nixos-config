{ inputs, lib, config, pkgs, ... }: {
  services.mako = {
    enable = true;
    defaultTimeout = 4500;
    ignoreTimeout = true;
  };
}
