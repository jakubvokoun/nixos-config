# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }:
let llm-agents = builtins.getFlake "github:numtide/llm-agents.nix";
in {
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
    ./nixvim.nix
    ./redshift.nix
    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./cinnamon.nix
    ./ulauncher.nix
    ./zellij.nix
    ./ansible-lsp.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      llm-agents.overlays.default

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
    nixfmt-classic
    compose2nix

    # Python
    (pkgs.python313.withPackages (ppkgs: [
      ppkgs.bpython
      ppkgs.ipython
      ppkgs.pip-tools
      ppkgs.numpy
      ppkgs.pandas
      ppkgs.torch
      ppkgs.jupyter
      ppkgs.matplotlib
      ppkgs.scikit-learn
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
      extensions = ({ enabled, all }:
        enabled ++ (with all; [
          php84Extensions.xdebug
          php84Extensions.pcov
          php84Extensions.tokenizer
        ]));
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
    pom
    sqlite
    mariadb.client
    mycli
    pgcli
    litecli
    ranger
    tlrc
    unzip
    shellcheck
    shellspec
    shfmt
    viddy
    yazi
    openssl
    ast-grep
    systemctl-tui
    dive
    openvpn
    mermaid-cli
    typst
    tinymist
    typstyle
    mdformat
    yamlfix
    smartmontools
    gopass

    # NodeJS
    nodejs
    yarn
    yarn2nix
    bun

    # Browsers
    google-chrome
    firefox
    librewolf
    vivaldi

    # Communication
    thunderbird
    slack
    wasistlos
    telegram-desktop
    viber

    # FTP
    filezilla

    # Printing
    system-config-printer

    # Work
    awscli2
    aws-vault
    ansible
    ansible-lint
    devtoolbox
    gnumake
    just
    kubernetes-helm
    k6
    k9s
    kdash
    kind
    kail
    kns
    kubebuilder
    kubectl
    kubectl-ktop
    kubelogin
    kubelogin-oidc
    kustomize
    kubectx
    minikube
    teleport_18
    tenv
    vagrant
    sublime4
    dig
    dogdns
    packer
    geany
    checkov
    djlint
    hadolint
    trivy
    lazyjournal
    tilt

    # Office
    libreoffice-still
    hunspell
    hunspellDicts.cs_CZ
    hunspellDicts.en_US
    hunspellDicts.de_DE
    marp-cli
    gnuplot
    galculator

    # Multimedia
    gimp
    inkscape
    audacity
    mpv
    vlc
    simplescreenrecorder

    # Misc
    meld
    blueman
    keepassxc
    seahorse
    obsidian
    sourcegit
    pandoc
    cheese
    gnome-pomodoro

    # 3D print
    openscad
    super-slicer

    # XDG
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome

    # IDE
    jetbrains.pycharm-oss
    kiro

    # AI
    pkgs.llm-agents.claude-code
    pkgs.llm-agents.openspec
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  xsession = {
    enable = true;
    profileExtra = ''
      export $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
    '';
  };
}

