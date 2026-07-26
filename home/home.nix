# This is your home-manager configuration file.
# Evaluated as a NixOS module via home-manager.nixosModules.home-manager,
# with useGlobalPkgs = true and useUserPackages = true (see ../flake.nix).

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./packages.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./ghostty.nix
    ./nixvim.nix
    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./gpg.nix
    ./gnome.nix
    #./ld.nix
  ];

  # ./work.nix is added per host by flake.nix.

  # `nixpkgs.*` is owned by the system config under useGlobalPkgs, and allowUnfree
  # is already set there. `home.username`/`homeDirectory` come from users.users.jakub.

  # Share the single unstable instance with modules that need it.
  _module.args.pkgsUnstable = pkgsUnstable;

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
