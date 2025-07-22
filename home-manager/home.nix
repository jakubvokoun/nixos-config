# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./fonts.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./helix.nix
    ./kitty.nix
    ./nixvim.nix
    ./redshift.nix
    ./starship.nix
    ./tmux.nix
    ./vscode.nix

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
    nixfmt-classic

    # Python
    (pkgs.python313.withPackages (ppkgs: [
      ppkgs.bpython
      ppkgs.ipython
      ppkgs.pip-tools
      ppkgs.numpy
      ppkgs.pandas
      ppkgs.torch
      ppkgs.jupyter
    ]))
    pipenv
    poetry

    # Go
    go_1_23
    gopls
    delve
    templ

    # PHP
    (pkgs.php83.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [ ]));
    })
    php83Packages.composer
    php83Packages.deployer

    # Basic CLI apps
    screen
    htop
    btop
    mc
    duf
    bat
    ripgrep
    taskwarrior3
    vit
    dstask
    tig
    jq
    yq
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
    mysql-client
    mycli
    pgcli
    litecli
    ranger
    tlrc
    unzip
    shellcheck
    shfmt
    viddy
    yazi
    openssl
    ast-grep

    # NodeJS
    nodejs
    bun

    # Browsers
    google-chrome
    firefox
    librewolf
    vivaldi

    # Communication
    thunderbird
    slack
    whatsapp-for-linux
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
    teleport_16
    tenv
    vagrant
    sublime4
    dig
    dogdns
    packer
    geany

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
    audacity
    mpv
    vlc
    simplescreenrecorder
    spot

    # Misc
    meld
    blueman
    keepassxc
    seahorse
    obsidian
    sourcegit
    albert

    # 3D print
    openscad
    super-slicer

    # Terminals
    tilix
    ptyxis

    # XDG
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };
}

