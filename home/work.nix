{
  inputs,
  lib,
  config,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  # Ephemeral Chromium: disposable HOME+XDG on tmpfs, no persistence anywhere real.
  # Distinct name so it lives alongside the raw `chromium` (below) instead of
  # shadowing it. Reused by the Selenium MCP server (see gitlab-mcp/shell.nix),
  # which points CHROME_BIN at this same store path — no second chromium download.
  chromiumEphemeral = pkgs.writeShellScriptBin "chromium-ephemeral" ''
    base="''${XDG_RUNTIME_DIR:-/dev/shm}"
    session="$(mktemp -d "$base/chromium-ephemeral.XXXXXX")"
    export HOME="$session/home"
    export XDG_CONFIG_HOME="$session/config"
    export XDG_CACHE_HOME="$session/cache"
    export XDG_DATA_HOME="$session/data"
    export XDG_STATE_HOME="$session/state"
    mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
    exec ${pkgs.chromium}/bin/chromium \
      --no-first-run --no-default-browser-check \
      --disable-breakpad --disable-crash-reporter \
      --password-store=basic --use-mock-keychain \
      --disable-background-networking --disable-component-update \
      "$@"
  '';
in
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
    yubikey-manager
    yubioath-flutter
    ssss

    # Network & mail
    opendkim
    openfortivpn

    # Web UI testing (Selenium MCP + pytest-selenium)
    chromium # raw, persistent-profile browser
    chromiumEphemeral # `chromium-ephemeral` on PATH -> tmpfs-only, no profile survives
    chromedriver
  ];
}
