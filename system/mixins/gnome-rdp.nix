# GNOME Remote Desktop (RDP).
#
# Opt-in per host: a host enables it simply by adding this mixin to its
# `imports`. See https://wiki.nixos.org/wiki/Remote_Desktop#GNOME_RDP
#
# The system daemon only supports `credentials` (or Kerberos) authentication:
# an RDP client must present a username and password that are stored on the
# host with `grdctl --system rdp set-credentials`. Until they are set, the
# daemon denies every client ("Credentials are not set, denying client").
#
# The upstream NixOS module exposes only `enable`, so the TLS certificate, the
# credentials, and the "enable RDP" step are provisioned by the idempotent
# activation service below. Two secrets are kept out of the Nix store: the
# self-signed TLS key is generated on the host, and the RDP password is read
# at activation time from a root-only file that lives outside git:
#
#   /etc/gnome-remote-desktop/credentials   (mode 0600, root:root)
#
# The file is sourced by the activation service, so it is shell key=value:
#
#   GRD_RDP_USERNAME=jakub
#   GRD_RDP_PASSWORD=<strong password>
#
# After creating or changing it, run `systemctl restart
# gnome-remote-desktop-setup.service` (a rebuild does the same). If the file is
# absent the server still comes up but stays credential-less (and so denies
# clients) — everything else is still declared.
#
# Access is over Tailscale only. The daemon binds 0.0.0.0:3389, but port 3389
# is opened solely on the `tailscale0` interface (below), never on the LAN or
# any public interface. So the desktop is reachable from the tailnet and
# nowhere else, which also carries RDP's weak self-signed TLS inside the
# tailnet's key-authenticated WireGuard transport. Import `tailscale.nix`
# alongside this mixin and run `sudo tailscale up` once per host; then point an
# RDP client (remmina) at the host's MagicDNS name or 100.x address on 3389.
#
# The password reaches grdctl as an argument, so it is briefly visible in
# root's process list and in the journal (pkexec logs the grdctl invocation).
# The tailnet-only exposure keeps that acceptable; do not open 3389 on a public
# interface.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  credentialsFile = "/etc/gnome-remote-desktop/credentials";
in
{
  services.gnome.gnome-remote-desktop.enable = true;

  # `services.gnome.gnome-remote-desktop.enable` alone does not make the unit
  # start with the graphical session, so wire it into graphical.target.
  systemd.services.gnome-remote-desktop.wantedBy = [ "graphical.target" ];

  # The daemon binds 0.0.0.0:3389, but the port is opened only on the tailscale0
  # interface — reachable from the tailnet, never from the LAN or public net
  # (see header). Requires the tailscale.nix mixin, which provides tailscale0.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];

  # Generate a self-signed TLS certificate (once), set the RDP credentials from
  # the out-of-store file if present, and turn RDP on. Idempotent: it
  # regenerates nothing that already exists and every `grdctl` call is safe to
  # re-run, so it converges on each rebuild without a separate manual step.
  systemd.services.gnome-remote-desktop-setup = {
    description = "Provision GNOME Remote Desktop TLS certificate, credentials and enable RDP";
    wantedBy = [ "graphical.target" ];
    before = [ "gnome-remote-desktop.service" ];
    path = [
      pkgs.openssl
      pkgs.gnome-remote-desktop
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # A live `nixos-rebuild switch` does not restart the already-running
      # daemon, so it would not pick up the freshly enabled RDP config until
      # the next boot. Queue a restart so the switch converges immediately.
      # --no-block is required: the daemon is ordered After this unit, so a
      # blocking restart would wait on a job that cannot run until this unit
      # finishes — a deadlock. At boot this is a harmless no-op (try-restart
      # only acts on an already-running daemon, which ordering starts later).
      ExecStartPost = "${pkgs.systemd}/bin/systemctl --no-block try-restart gnome-remote-desktop.service";
    };
    script = ''
      # grdctl --system elevates via the pkexec setuid wrapper; as root it is
      # authorized without a prompt, but the wrapper dir is not on the unit PATH.
      export PATH="/run/wrappers/bin:$PATH"

      dir=/var/lib/gnome-remote-desktop
      install -d -o gnome-remote-desktop -g gnome-remote-desktop -m 0700 "$dir"
      if [ ! -f "$dir/tls.crt" ] || [ ! -f "$dir/tls.key" ]; then
        openssl req -x509 -newkey rsa:4096 -nodes -days 3650 \
          -subj "/CN=${config.networking.hostName}" \
          -keyout "$dir/tls.key" -out "$dir/tls.crt"
      fi
      chown gnome-remote-desktop:gnome-remote-desktop "$dir/tls.crt" "$dir/tls.key"
      chmod 0600 "$dir/tls.key"
      chmod 0644 "$dir/tls.crt"

      grdctl --system rdp set-tls-cert "$dir/tls.crt"
      grdctl --system rdp set-tls-key "$dir/tls.key"
      grdctl --system rdp set-auth-methods credentials

      # Load the RDP credentials from the root-only file if it exists. The
      # password reaches grdctl as an argument (visible only in root's process
      # list for an instant), never touching the Nix store or git.
      if [ -r "${credentialsFile}" ]; then
        GRD_RDP_USERNAME=""
        GRD_RDP_PASSWORD=""
        . "${credentialsFile}"
        if [ -n "$GRD_RDP_USERNAME" ] && [ -n "$GRD_RDP_PASSWORD" ]; then
          grdctl --system rdp set-credentials "$GRD_RDP_USERNAME" "$GRD_RDP_PASSWORD"
        fi
      fi

      grdctl --system rdp enable
    '';
  };
}
