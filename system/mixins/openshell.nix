# NVIDIA OpenShell 0.1.x: sandboxed agent runtime on rootless Podman.
#
# - Package: ../packages/openshell.nix (upstream release binaries).
# - Gateway: per-user systemd unit, a port of upstream's RPM unit
#   (deploy/rpm), started with every user session. It listens on
#   https://127.0.0.1:17670 (mTLS). On first start it seeds
#   ~/.config/openshell/gateway.toml (Podman driver pinned) and generates PKI;
#   the CLI picks up the client certs from ~/.config/openshell/gateways/.
# - ~/.config/openshell/gateway.toml stays user-owned, so a sandbox image and
#   pull policy can change without a rebuild (~/tmp/openshell-podman/setup.sh
#   writes it).
# - Requires podman.nix: the gateway talks to the rootless per-user Podman
#   socket and pulls its supervisor images from ghcr.io/nvidia/openshell/.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  openshell = pkgs.callPackage ../packages/openshell.nix { };

  # Upstream deploy/rpm/gateway.toml.default, minus comments.
  defaultConfig = pkgs.writeText "openshell-gateway.toml" ''
    [openshell]
    version = 2

    [openshell.gateway]
    # Without this the gateway auto-detects Kubernetes, Podman, Docker in that
    # order; dockerCompat makes the Docker driver a candidate too.
    compute_driver = "podman"

    [openshell.drivers.podman]
    health_check_interval_secs = 10
  '';

  # Copy the default only when absent; an existing file is user-owned.
  seedConfig = pkgs.writeShellScript "openshell-gateway-seed-config" ''
    set -eu
    dest="$1"
    if [ -L "$dest" ] || { [ -e "$dest" ] && [ ! -f "$dest" ]; }; then
      echo "refusing to replace non-regular gateway config: $dest" >&2
      exit 1
    fi
    [ -e "$dest" ] && exit 0
    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$dest")"
    ${pkgs.coreutils}/bin/install -m 0644 ${defaultConfig} "$dest"
  '';
in
{
  assertions = [
    {
      assertion = config.virtualisation.podman.enable;
      message = "openshell.nix requires podman.nix (virtualisation.podman.enable).";
    }
  ];

  environment.systemPackages = [ openshell ];

  systemd.user.services.openshell-gateway = {
    description = "OpenShell Gateway (user)";
    documentation = [ "https://github.com/NVIDIA/OpenShell" ];
    after = [ "podman.socket" ];
    wants = [ "podman.socket" ];
    wantedBy = [ "default.target" ];

    # The Podman driver runs `podman info` to locate the API socket.
    path = [ config.virtualisation.podman.package ];

    environment.OPENSHELL_LOCAL_TLS_DIR = "%h/.local/state/openshell/tls";

    serviceConfig = {
      Type = "exec";
      ExecStartPre = [
        "${seedConfig} %E/openshell/gateway.toml"
        "${openshell}/bin/openshell-gateway config preflight"
        "${openshell}/bin/openshell-gateway generate-certs --output-dir \${OPENSHELL_LOCAL_TLS_DIR} --server-san host.openshell.internal"
      ];
      ExecStart = "${openshell}/bin/openshell-gateway";
      EnvironmentFile = "-%E/openshell/gateway.env";
      StateDirectory = "openshell";
      Restart = "on-failure";
      RestartSec = 5;

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      PrivateTmp = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
    };
  };
}
