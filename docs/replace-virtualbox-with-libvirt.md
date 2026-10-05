# Task: Replace VirtualBox with libvirt (KVM)

Evaluate whether the `virtualbox.nix` mixin can be dropped in favour of `libvirt.nix` and/or `incus.nix`. Main workloads: Vagrant boxes and Claude testing sessions (booting LM appliance VMs).

## Verdict

**libvirt (KVM) can fully replace VirtualBox for both workloads. Incus cannot drive Vagrant — keep it for containers only, not as a VirtualBox replacement.**

## Findings (e14, 2026-09-21)

Everything needed for the switch is already in place:

- `vagrant-libvirt` (0.12.2) is installed as a system plugin.
- `/dev/kvm` is present and CPU hardware virtualisation (vmx/svm) is enabled. KVM is faster than VirtualBox.
- LM OVA appliances already boot locally under plain QEMU (vmxnet3 NIC, slirp networking) — that path never used VirtualBox.
- `qemu` and `quickemu` are already in `home/work.nix`.

Only real friction is **box format**. The one installed box, `bento/ubuntu-26.04`, is VirtualBox-format. bento publishes a libvirt variant, so it can simply be re-added.

### Why not Incus

- No maintained Vagrant provider for Incus/LXD; `.box` files cannot drive it.
- Incus VMs are QEMU under the hood but are not fed by Vagrant boxes.
- Incus stays useful for container experiments only. It replaces nothing VirtualBox does for OVA/appliance testing.

### Not affected

The CI OVA/VHDX build runners (`stage:virt-logmanager`) are separate machines. This change is local to the e14 host and does not touch them.

## Migration steps

1. Set the default Vagrant provider so no `--provider` flag is needed each time. In `home/work.nix`:
   ```nix
   home.sessionVariables.VAGRANT_DEFAULT_PROVIDER = "libvirt";
   ```
2. Re-add boxes in libvirt format:
   ```
   vagrant box add bento/ubuntu-26.04 --provider libvirt
   ```
   For boxes with no libvirt variant, convert the disk with `qemu-img` (vmdk -> qcow2) or use the `vagrant mutate` plugin.
3. Test one `vagrant up` end to end.
4. Remove `../../mixins/virtualbox.nix` from `system/hosts/e14/default.nix`; keep `libvirt.nix`.
5. Rebuild. The `vboxusers` group and the Extension Pack are then gone.

## Status

**Config applied (2026-10-05)** — steps 1 and 4 are done in the repo: `VAGRANT_DEFAULT_PROVIDER = "libvirt"` is set in `home/work.nix`, and e14 no longer imports `virtualbox.nix`. The mixin file stays in `system/mixins/` as an opt-in, like the other unused mixins.

e14 is rebuilt (step 5). Still pending: re-add boxes in libvirt format and test one `vagrant up` (steps 2-3). Afterwards, remove the old VirtualBox-format box with `vagrant box remove bento/ubuntu-26.04 --provider virtualbox`.
