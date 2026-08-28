{
  inputs,
  lib,
  config,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  # Tooling needed for client work.
  #
  # Credentials are deliberately absent: home-manager renders its generated
  # dotfiles into world-readable /nix/store paths, so no token may be declared
  # in Nix. Per-host git credentials go in ~/.config/git/local (0600, untracked),
  # pulled in by programs.git.includes in ./git.nix.

  home.packages = with pkgs; [
    # Python tooling
    python313Packages.black
    python313Packages.isort
    python313Packages.junit2html
    python313Packages.mypy
    python313Packages.pre-commit-hooks
    python313Packages.pylint
    python313Packages.pyupgrade
    python313Packages.pyvmomi
    python313Packages.reorder-python-imports

    # Virtualization & images
    govc
    qemu
    quickemu
    squashfs-tools-ng
    squashfsTools

    # Dev tooling
    lnav
    pre-commit
    pkgsUnstable.kiro

    # Security & supply chain
    cyclonedx-cli

    # Network & mail
    opendkim
    openfortivpn
  ];
}
