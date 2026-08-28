# The full user package set, shared by every host.
{
  inputs,
  lib,
  config,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    # Nix tools
    compose2nix
    nh
    nixfmt

    # Python
    (pkgs.python313.withPackages (ppkgs: [
      ppkgs.ipython
      ppkgs.pip-tools
    ]))

    # Go
    air
    delve
    go_1_25
    gocover-cobertura
    gopls
    gotestsum
    gotools
    templ

    # Rust
    gcc
    rustup

    # NodeJS
    bun
    nodejs

    # CLI - system & monitoring
    btop
    duf
    fastfetch
    htop
    smartmontools
    systemctl-tui
    viddy
    wiper

    # CLI - files & navigation
    bat
    fd
    mc
    ranger
    tree
    unzip
    yazi

    # CLI - search, text & data
    glow
    jq
    mdformat
    ripgrep
    slides
    yamlfix
    yamlfmt
    yq-go

    # CLI - git & containers
    dive
    lazydocker
    lazygit
    tig

    # CLI - databases
    litecli
    mariadb.client
    mycli
    pgcli
    sqlite

    # CLI - security & secrets
    age
    gnupg
    gopass
    openssl
    sops

    # CLI - shell tooling
    shellcheck
    shellspec
    shfmt
    tlrc

    # CLI - docs & misc
    mermaid-cli
    openvpn
    tinymist
    typst
    typstyle

    # Browsers
    firefox
    google-chrome
    librewolf

    # Communication
    karere
    slack
    thunderbird

    # FTP
    filezilla

    # Work - cloud & infra
    ansible
    ansible-language-server
    ansible-lint
    awscli2
    aws-vault
    dig
    doggo
    packer
    tenv
    vagrant

    # Work - kubernetes
    k6
    k9s
    kind
    kubectl
    kubectx
    kubernetes-helm
    helm-ls
    kustomize
    minikube
    tilt

    # Work - build & CI
    bazel
    gitlab-ci-local
    gnumake
    just
    pkgsUnstable.gh
    pkgsUnstable.glab
    prettier

    # Work - security & supply chain
    checkov
    cosign
    djlint
    gitleaks
    hadolint
    lazyjournal
    semgrep
    pkgsUnstable.grype
    pkgsUnstable.syft
    pkgsUnstable.trivy
    pkgsUnstable.zarf

    # Work GUI
    devtoolbox
    gitg
    seabird
    sourcegit

    # Office
    galculator
    gnuplot
    hunspell
    hunspellDicts.cs_CZ
    hunspellDicts.de_DE
    hunspellDicts.en_US
    libreoffice-still
    marp-cli
    obsidian

    # Multimedia
    audacity
    gimp
    inkscape
    spotify

    # Misc
    cheese
    gnome-pomodoro
    keepassxc
    meld
    newsflash
    overskride
    seahorse

    # 3D print
    openscad
    super-slicer

    # AI
    llm-agents.claude-code
    llm-agents.codegraph
    llm-agents.opencode
    llm-agents.openspec
  ];
}
