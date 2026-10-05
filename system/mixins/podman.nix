# Podman as a drop-in Docker replacement: daemonless, rootless by default.
#
# - `docker` is a shim to `podman` (dockerCompat), so scripts and muscle memory
#   keep working. Conflicts with docker.nix / rootless-docker.nix.
# - `docker compose` / `podman compose` run docker-compose against the Podman
#   API socket.
# - Rootless networking uses pasta (passt), bundled in podman's helper binaries.
# - DOCKER_HOST points at the per-user Podman socket, so Docker API clients
#   (lazydocker, dive, docker-compose, testcontainers, VS Code) talk to rootless
#   Podman without a root daemon.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    # Containers on the default network resolve each other by name, as with
    # Docker's user-defined networks; docker-compose relies on this.
    defaultNetwork.settings.dns_enabled = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  virtualisation.containers = {
    enable = true;
    containersConf.settings = {
      network.default_rootless_network_cmd = "pasta";
      # podman compose finds docker-compose (systemPackages) on PATH by itself;
      # this only drops its "executing external compose provider" banner.
      engine.compose_warning_logs = false;
    };
    # Short names (`nginx`, `postgres:16`) resolve to Docker Hub, as with Docker.
    registries.search = [ "docker.io" ];
  };

  # Same approach as virtualisation.docker.rootless.setSocketVariable. The
  # socket itself is socket-activated per user by the podman module.
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';

  environment.systemPackages = with pkgs; [
    docker-compose
    # GUI
    podman-desktop
    pods
    # TUI
    podman-tui
    lazydocker
    oxker
    dive
  ];

  # Access to the rootful system socket (/run/podman/podman.sock), for the odd
  # tool that needs real root containers. Root-equivalent, like the docker group.
  users.users.jakub.extraGroups = [ "podman" ];
}
