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
    nixfmt
    compose2nix
    nh

    # Python
    (pkgs.python313.withPackages (ppkgs: [
      ppkgs.ipython
      ppkgs.pip-tools
    ]))

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
    wiper

    # NodeJS
    nodejs
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
    dig
    doggo
    packer
    checkov
    djlint
    hadolint
    lazyjournal
    tilt
    bazel
    semgrep
    gitlab-ci-local
    gitleaks
    prettier
    pkgsUnstable.glab
    pkgsUnstable.gh
    pkgsUnstable.trivy
    pkgsUnstable.syft
    pkgsUnstable.grype
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
    spotify

    # Misc
    meld
    overskride
    keepassxc
    seahorse
    cheese
    gnome-pomodoro
    newsflash

    # 3D print
    openscad
    super-slicer

    # AI
    llm-agents.claude-code
    llm-agents.opencode
    llm-agents.openspec
    llm-agents.codegraph
  ];
}
