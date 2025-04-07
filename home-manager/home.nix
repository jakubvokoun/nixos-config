# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    #./nvim.nix
    ./nixvim.nix
    ./helix.nix
    ./fonts.nix
    ./zsh.nix
    #./zsh-powerline-go.nix
    #./starship.nix
    ./fzf.nix
    ./git.nix
    ./redshift.nix
    ./alacritty.nix
    ./kitty.nix
    #./plasma.nix
    ./i3.nix
    ./style.nix
    #./sway.nix
    ./vscode.nix
    # Experimental
    ./zed.nix
    ./ghostty.nix
    ./wezterm.nix
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
    (pkgs.python311.withPackages (ppkgs: [ ppkgs.bpython ]))
    pipenv
    poetry

    # Go
    go_1_22
    gopls
    delve

    # Rust
    rustc
    rustfmt
    gcc
    cargo

    # PHP
    (pkgs.php83.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [ ]));
    })
    php83Packages.composer
    php83Packages.deployer

    # Basic CLI apps
    tmux
    screen
    zellij
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
    neofetch
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

    # NodeJS
    bun

    # Browsers
    google-chrome
    firefox
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
    gnumake
    jetbrains.pycharm-community
    jetbrains.phpstorm
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
    teleport_15
    tenv
    vagrant
    sublime4

    # Office
    libreoffice-still
    hunspell
    hunspellDicts.cs_CZ
    hunspellDicts.en_US
    hunspellDicts.de_DE
    marp-cli
    errands
    wxmaxima
    octaveFull
    gnuplot
    galculator
    evince

    # Multimedia
    gimp
    audacity

    # Misc
    meld
    blueman
    xarchiver
    keepassxc

    # 3D print
    openscad
    # TODO
    #orca-slicer
    super-slicer
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "DMZ-White";
    size = 24;
    package = pkgs.vanilla-dmz;
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
        "text/html" = [ "google-chrome.desktop" ];
        "application/pdf" = "org.gnome.Evince.desktop";
        "image/png" = [ "org.xfce.ristretto.desktop" "gimp.desktop" ];
        "image/jpg" = [ "org.xfce.ristretto.desktop" "gimp.desktop" ];
        "image/jpeg" = [ "org.xfce.ristretto.desktop" "gimp.desktop" ];
        "image/tiff" = [ "org.xfce.ristretto.desktop" "gimp.desktop" ];
      };
      defaultApplications = {
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
        "text/html" = [ "google-chrome.desktop" ];
        "application/pdf" = "org.gnome.Evince.desktop";
        "image/png" = [ "org.xfce.ristretto.desktop" ];
        "image/jpg" = [ "org.xfce.ristretto.desktop" ];
        "image/jpeg" = [ "org.xfce.ristretto.desktop" ];
        "image/tiff" = [ "org.xfce.ristretto.desktop" ];
      };
    };
  };
}

