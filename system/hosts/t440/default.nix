# ThinkPad T440. Haswell, 8 GB RAM, spinning-rust-era SATA SSD — deliberately
# slimmer than the E14: no VirtualBox, no libvirt, no incus, no work tooling.
{ lib, ... }:
{
  imports = [
    ./hardware.nix
    ../../mixins/docker.nix
    ../../mixins/gnome.nix
    ../../mixins/kmscon.nix
  ];

  networking.hostName = "t440";

  # Legacy BIOS boot, and os-prober picks up the other system on the disk.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  boot.kernelModules = [
    "wireguard"
    "iptable_nat"
    "ip6table_nat"
    "xt_masquerade"
  ];

  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";

  users.users.jakub.extraGroups = [ "video" ];

  # Half the core count of the E14.
  nix.settings.max-jobs = lib.mkForce 4;

  # Pins stateful defaults to the release this host was installed from. Never bump.
  system.stateVersion = "24.11";
}
