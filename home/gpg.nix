{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  # Auto-select pinentry: GUI popup when a graphical session exists (so it does
  # not grab the TTY an interactive CLI runs in), curses otherwise (SSH /
  # headless). The binary MUST be named `pinentry`: home-manager wires the agent
  # to `${package}/bin/pinentry`, so a differently-named wrapper leaves the agent
  # with no pinentry and every decrypt fails silently.
  pinentry-auto = pkgs.writeShellScriptBin "pinentry" ''
    if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
      exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@"
    else
      exec ${pkgs.pinentry-curses}/bin/pinentry-curses "$@"
    fi
  '';
in
{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 999999;
    pinentry.package = pinentry-auto;
    # In headless/SSH the curses branch cannot prompt a *background* process
    # (e.g. an MCP server that reads a gopass secret at launch), so prime the
    # cache interactively first - see the README (gopass / gpg-agent).
  };
}
