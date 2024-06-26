# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./nvim.nix
    ./fonts.nix
    ./zsh.nix
    ./fzf.nix
    ./git.nix
    ./redshift.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "jakub";
    homeDirectory = "/home/jakub";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Nix tools
    niv

    # Python
    (pkgs.python311.withPackages (ppkgs: []))

    # Go
    go_1_20

    # PHP
    (pkgs.php83.buildEnv {
      extensions = ({enabled, all}: enabled ++ (with all; []));
    })
    php83Packages.composer

    # Basic CLI apps
    tmux
    zellij
    htop
    mc
    duf
    bat
    ripgrep
    taskwarrior
    vit
    tig
    jq
    yq
    tree
    glow
    lazygit
    lazydocker
    neofetch

    # Neovim
    lua5_4_compat
    nodejs_20
    gcc
    unzip

    # Browsers
    firefox
    google-chrome
    vivaldi
    brave

    # Communication
    thunderbird
    slack

    # FTP
    filezilla

    # Printing
    system-config-printer

    # Work
    awscli2
    aws-vault
    ansible
    ansible-lint
    gnumake
    k6
    teleport_14
    terraform
    vagrant
    vscode

    # Office
    libreoffice-still
    hunspell
    hunspellDicts.cs_CZ
    hunspellDicts.en_US
    hunspellDicts.de_DE

    # Multimedia
    gimp
    audacity

    # Misc
    meld
    etcher

    # KDE
    pkgs.libsForQt5.kompare
    pkgs.libsForQt5.yakuake
    pkgs.libsForQt5.ksshaskpass
    pkgs.libsForQt5.akonadi
    pkgs.libsForQt5.kdepim-runtime
    pkgs.libsForQt5.korganizer
    pkgs.libsForQt5.kate
    pkgs.libsForQt5.kwrited
    pkgs.libsForQt5.kdevelop
    pkgs.libsForQt5.kdev-php
    pkgs.libsForQt5.kdev-python
    pkgs.libsForQt5.keditbookmarks
    pkgs.krusader
    pkgs.krename
 ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}

