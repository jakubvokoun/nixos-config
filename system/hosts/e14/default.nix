# ThinkPad E14 Gen 3.
{ ... }:
{
  imports = [
    ./hardware.nix
    ../../mixins/docker.nix
    ../../mixins/gnome.nix
    ../../mixins/gnome-rdp.nix
    ../../mixins/tailscale.nix
    ../../mixins/virtualbox.nix
    ../../mixins/libvirt.nix
    ../../mixins/kmscon.nix
    #../../mixins/incus.nix
  ];

  networking.hostName = "e14";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # No `devices` listed: smartd scans whatever physical disk is attached.
  services.smartd.enable = true;

  # Pins stateful defaults to the release this host was installed from. Never bump.
  system.stateVersion = "24.05";

  # TRIM and reduced write amplification on SSD.
  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
  ];
}
