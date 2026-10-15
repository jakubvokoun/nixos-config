{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  # `pkgsUnstable` is only a home-manager module arg (home/home.nix), not a
  # NixOS one, so build the instance here from the flake input.
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "jakub" ];

  environment.systemPackages = with pkgs; [
    # CLI & TUI
    pkgsUnstable.docker-sbx
    lazydocker
    oxker
    dive
    # Other
    toolbox
    distrobox
    distrobox-tui
  ];
}
