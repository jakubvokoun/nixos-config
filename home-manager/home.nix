# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  llm-agents = import ./llm-agents.nix {
    inherit (pkgs.stdenv.hostPlatform) system;
  };
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./kitty.nix
    ./wezterm.nix
    ./ghostty.nix
    ./nixvim.nix
    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./zed.nix
    ./zellij.nix
    ./gpg.nix
    ./gnome.nix
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
    nixfmt
    compose2nix
    nh

    # Python
    (pkgs.python313.withPackages (ppkgs: [
      ppkgs.ipython
      ppkgs.pip-tools
      ppkgs.numpy
      ppkgs.pandas
      ppkgs.jupyter
      ppkgs.matplotlib
    ]))
    pipenv
    poetry

    # Go
    go_1_25
    gopls
    gotools
    gotestsum
    gocover-cobertura
    delve
    templ
    air

    # Rust
    rustup
    gcc

    # PHP
    (pkgs.php84.buildEnv {
      extensions = (
        { enabled, all }:
        enabled
        ++ (with all; [
          php84Extensions.xdebug
          php84Extensions.pcov
          php84Extensions.tokenizer
        ])
      );
    })
    php84Packages.composer
    deployer

    # Basic CLI apps
    htop
    btop
    mc
    duf
    bat
    ripgrep
    fd
    tig
    jq
    yq-go
    tree
    glow
    slides
    lazygit
    lazydocker
    fastfetch
    gnupg
    sops
    age
    scrot
    sqlite
    mariadb.client
    mycli
    pgcli
    litecli
    tlrc
    unzip
    shellcheck
    shellspec
    shfmt
    viddy
    yazi
    ranger
    openssl
    systemctl-tui
    dive
    openvpn
    mermaid-cli
    typst
    tinymist
    typstyle
    mdformat
    yamlfix
    yamlfmt
    smartmontools
    gopass

    # NodeJS
    nodejs
    yarn
    bun

    # Browsers
    google-chrome
    firefox
    librewolf

    # Communication
    thunderbird
    slack
    karere

    # FTP
    filezilla

    # Printing
    system-config-printer

    # Work
    awscli2
    aws-vault
    ansible
    ansible-lint
    ansible-language-server
    gnumake
    just
    kubernetes-helm
    helm-ls
    k6
    k9s
    kind
    kubectl
    kustomize
    kubectx
    minikube
    tenv
    vagrant
    sublime4
    dig
    doggo
    packer
    geany
    checkov
    djlint
    hadolint
    trivy
    lazyjournal
    tilt
    bazel
    semgrep
    gitlab-ci-local
    gitleaks
    prettier
    tilt
    pkgsUnstable.glab
    pkgsUnstable.gh
    pkgsUnstable.zarf

    # Work GUI
    gitg
    devtoolbox
    sourcegit
    seabird

    # Office
    libreoffice-still
    hunspell
    hunspellDicts.cs_CZ
    hunspellDicts.en_US
    hunspellDicts.de_DE
    marp-cli
    gnuplot
    galculator
    obsidian

    # Multimedia
    gimp
    inkscape
    audacity
    mpv
    vlc
    spotify

    # Misc
    meld
    overskride
    keepassxc
    seahorse
    cheese
    gnome-pomodoro
    bleachbit
    newsflash

    # 3D print
    openscad
    super-slicer

    # AI
    llm-agents.claude-code
    llm-agents.opencode
    llm-agents.openspec
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
