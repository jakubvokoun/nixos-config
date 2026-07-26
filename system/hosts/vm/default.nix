# A generic host for testing, with no relationship to any real machine.
#
# It declares no LUKS devices, no partition labels and no firmware assumptions,
# so `nixos-rebuild build-vm --flake .#vm` works on any x86_64 machine —
# including one whose disks are laid out completely differently.
#
# Use it to exercise a change to the shared config or to the home-manager
# modules. Use `.#nixos` when the change is to the laptop's own hardware.
{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../mixins/gnome.nix
  ];

  networking.hostName = "vm";

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  # Placeholder root so the config also evaluates outside build-vm, which
  # replaces every filesystem with its own via mkVMOverride anyway.
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "26.05";
}
