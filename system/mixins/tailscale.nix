# Tailscale mesh VPN.
#
# Opt-in per host by adding this mixin to its `imports`. Enables the tailscaled
# daemon and installs `trayscale`, a GTK/libadwaita GUI to manage the tailnet
# (connect/disconnect, exit nodes, peer list). trayscale shows its tray icon
# through the AppIndicator GNOME extension already enabled in `gnome.nix`.
#
# After first boot, authenticate the host once with `sudo tailscale up`. RDP
# access (see `gnome-rdp.nix`) is opened only on the `tailscale0` interface, so
# the desktop is reachable from the tailnet and nowhere else.
{ pkgs, ... }:
{
  services.tailscale.enable = true;

  environment.systemPackages = [ pkgs.trayscale ];
}
