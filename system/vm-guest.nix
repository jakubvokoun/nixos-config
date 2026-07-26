# VM-only overrides for `nixos-rebuild build-vm`.
#
# Everything lives under virtualisation.vmVariant, so none of it applies to a
# real `nixos-rebuild switch` — this file is inert outside the VM build.
{ lib, ... }:
{
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 6144; # GNOME needs headroom
      cores = 4;
      diskSize = 8192;
      graphics = true;
      qemu.options = [ "-vga virtio" ];
    };

    # A fresh VM has no /etc/shadow state — without this you cannot log in.
    users.users.jakub.initialPassword = "poc";
    users.users.root.initialPassword = "poc";

    # Host-specific or expensive things that make no sense in the VM.
    services.smartd.enable = lib.mkForce false;
    documentation.man.cache.enable = lib.mkForce false;

    # Nested hypervisors inside the test VM: builds kernel modules for nothing.
    virtualisation.virtualbox.host.enable = lib.mkForce false;
    virtualisation.libvirtd.enable = lib.mkForce false;
  };
}
