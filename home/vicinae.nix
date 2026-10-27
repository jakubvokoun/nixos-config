{ inputs, pkgs, ... }:

{
  # Home Manager ships `programs.vicinae` itself, so the flake's
  # homeManagerModules.default is not imported (it declares the same options).
  # The package comes from the vicinae flake, cached on vicinae.cachix.org
  # (see system/cachix/vicinae.nix); nixpkgs' vicinae lags behind.
  programs.vicinae = {
    enable = true;
    package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd = {
      enable = true;
      autoStart = true;
    };
  };
}
