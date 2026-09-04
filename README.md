# NixOS Configuration

A single flake covering both the system and the user environment.
Home Manager runs as a NixOS module, so one `nixos-rebuild` applies everything.

## Table of Contents

- [Layout](#layout)
- [Hosts](#hosts)
- [Usage](#usage)
  - [Rebuild](#rebuild)
  - [Update](#update)
    - [Across both machines](#across-both-machines)
  - [Testing in a VM](#testing-in-a-vm)
  - [Garbage Collection](#garbage-collection)
- [Flake Inputs](#flake-inputs)
- [Secrets](#secrets)
  - [gopass and gpg-agent (SSH / headless)](#gopass-and-gpg-agent-ssh--headless)
- [Home Manager](#home-manager)
  - [Options](#options)
  - [User-level systemd services](#user-level-systemd-services)
  - [dconf](#dconf)
  - [Using unstable packages](#using-unstable-packages)
  - [Pinning a package to an exact version](#pinning-a-package-to-an-exact-version)
  - [Theme overrides](#theme-overrides)
- [System](#system)
  - [Mixins](#mixins)
  - [SSD](#ssd)
  - [Zsh](#zsh)
  - [Printing](#printing)
  - [Remote Desktop (RDP)](#remote-desktop-rdp)
  - [Virtualisation](#virtualisation)
- [Migrating an existing install](#migrating-an-existing-install)
- [Bootstrapping a new machine](#bootstrapping-a-new-machine)
- [Cachix](#cachix)
- [Reference Docs](#reference-docs)

______________________________________________________________________

## Layout

```
flake.nix           # inputs + nixosConfigurations, one per host
flake.lock          # locked revisions — commit every change to this
system/
  common.nix               # config shared by every host
  vm-guest.nix             # virtualisation.vmVariant overrides (inert outside build-vm)
  cachix.nix  cachix/
  mixins/*.nix             # optional system modules, imported by a host
  hosts/
    e14/                   # ThinkPad E14 Gen 3
      default.nix          #   hostname, bootloader, mixins, stateVersion
      hardware.nix         #   disks and hardware scan (UUIDs — machine-specific)
    t440/                  # ThinkPad T440
      default.nix
      hardware.nix
    vm/
      default.nix          # hardware-free host for testing
home/
  home.nix                 # Home Manager entry point, imports everything below
  packages.nix             # the user package set
  work.nix                 # work tooling — opt-in per host, see flake.nix
  *.nix                    # one module per program
  packages/                # locally packaged software
docs/               # notes on configs not currently in use
```

The repo **is** the configuration — there is nothing to copy into `/etc/nixos`
or `~/.config/home-manager`.

> **Note:** a flake evaluates from the git tree, so a new file is invisible to
> `nixos-rebuild` until it is at least `git add`ed. `error: … does not exist` on a
> file you can plainly see means exactly this. The same applies to
> `.gitignore`d files — they cannot be imported at all, even with `--impure`.

## Hosts

Each host is a directory under `system/hosts/`, composed by `mkHost` in
`flake.nix` with `system/common.nix`, `system/vm-guest.nix` and home-manager.
The host directory supplies only what is specific to that machine.

| Host | Purpose |
|---|---|
| `e14` | ThinkPad E14 Gen 3. UEFI, LUKS root and swap, Docker + VirtualBox + libvirt. |
| `t440` | ThinkPad T440. Legacy BIOS GRUB, no encryption, Docker only. No work tooling. |
| `vm` | Hardware-free. No LUKS, no partition UUIDs, no firmware assumptions — builds on any x86_64 machine. |

`mkHost` takes `work` (default `true`), which decides whether `home/work.nix`
is imported. Everything else in `home/` is identical on every host.

Adding a machine is one directory plus one entry:

```nix
# flake.nix
nixosConfigurations = {
  e14 = mkHost { name = "e14"; };
  t440 = mkHost { name = "t440"; work = false; };
  vm = mkHost { name = "vm"; };
};
```

```sh
mkdir system/hosts/laptop2
nixos-generate-config --show-hardware-config > system/hosts/laptop2/hardware.nix
$EDITOR system/hosts/laptop2/default.nix    # hostname, bootloader, mixins, stateVersion
git add system/hosts/laptop2
```

`hardware.nix` holds filesystem and LUKS UUIDs. Those are specific to one
machine by design — that is the file that makes a host a host.

## Usage

### Rebuild

```sh
sudo nixos-rebuild switch --flake ~/Repos/nixos-config#e14
# or, with nh:
nh os switch ~/Repos/nixos-config
```

The attribute name matches `networking.hostName`, so on the machine itself the
`#e14` / `#t440` suffix can be omitted.

Build without activating:

```sh
nixos-rebuild build --flake ~/Repos/nixos-config#e14
```

Roll back:

```sh
sudo nixos-rebuild switch --rollback
nixos-rebuild list-generations
```

### Update

Package versions come from `flake.lock`, not from the network. A rebuild never
changes what you get — only updating the lockfile does. There is no
`nixos-rebuild --upgrade` here; that flag is for channels.

```sh
nix flake update                    # all inputs
nix flake update nixpkgs            # just one
nix flake metadata                  # show what is locked right now
```

Then rebuild, and **commit `flake.lock`** — it is the record of what every
machine is running.

#### Across both machines

The lockfile is shared, so an update is a repo change, not a per-machine
action. Do it once, push, and pull it everywhere else:

```sh
# on whichever machine you are at
nix flake update
sudo nixos-rebuild switch --flake .        # verify it actually works here
git commit -am 'chore: update flake.lock'
git push

# on the other machine
git pull
sudo nixos-rebuild switch --flake .
```

Both hosts then run identical package versions, which is the property the
lockfile exists to give you.

Two things to watch:

- The `upgrade-nixos` alias runs `nix flake update` and switches, but does not
  commit or push. Run it on one machine only, then commit — otherwise each
  machine ends up with its own lock and they drift apart.
- A dirty or unpulled clone silently builds something different. `nixos-rebuild`
  warns `Git tree ... is dirty`; that warning means the build does not match
  what is committed.

To move to a new NixOS release, change the branch in the input URLs — both
`nixpkgs` and `home-manager` together, they are versioned in lockstep — then
`nix flake update`:

```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.11";
home-manager.url = "github:nix-community/home-manager/release-26.11";
nixvim.url = "github:nix-community/nixvim/nixos-26.11";
```

Leave `system.stateVersion` and `home.stateVersion` alone when you do — they
record the release a machine was installed from, not the one it runs.

### Testing in a VM

Use the `vm` host. It declares no LUKS devices, no partition UUIDs and no
firmware assumptions, so it boots regardless of how the building machine's
disks are laid out:

```sh
nixos-rebuild build-vm --flake ~/Repos/nixos-config#vm
./result/bin/run-nixos-vm
```

Log in as `jakub` with the password set in `system/vm-guest.nix` — a fresh VM
has no `/etc/shadow` state, so without `initialPassword` there is no way in.
The VM shares the host nix store, so the build is small when the closure is
mostly present already.

Headless, with SSH forwarded to port 2222:

```sh
QEMU_NET_OPTS="hostfwd=tcp::2222-:22" \
QEMU_OPTS="-display none -serial file:/tmp/vm-console.log" \
  ./result/bin/run-nixos-vm

ssh -p 2222 jakub@localhost
```

`nixos.qcow2` is a scratch disk created in the working directory; delete it
between runs for a clean boot.

`system/vm-guest.nix` applies to every host, but everything in it sits under
`virtualisation.vmVariant`, so it can never affect a real switch. Building
`#e14` as a VM also works, but it drags in that laptop's disk layout for no
benefit — prefer `#vm` unless the change is to the hardware config itself.

### Garbage Collection

Automatic, weekly, keeping 15 days (`system/common.nix`):

```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 15d";
};
```

Manual:

```sh
sudo nix-collect-garbage --delete-older-than 15d
nix-collect-garbage -d
```

## Flake Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | `nixos-26.05` — the system package set |
| `nixpkgs-unstable` | a few packages that need to be newer than the release |
| `home-manager` | `release-26.05`, `follows` nixpkgs |
| `llm-agents` | claude-code, opencode, openspec, codegraph |
| `nixvim` | the Neovim configuration framework, `follows` nixpkgs |

Everything is locked in `flake.lock`. Nothing fetches from a moving branch at
evaluation time — that property is the point of the flake, so avoid
`builtins.fetchGit` / `fetchTarball` / `<nixpkgs>` in modules. Use a pinned
`pkgs.fetchFromGitHub` with a hash where a raw source is genuinely needed
(`home/starship.nix` does this for a zsh plugin).

## Secrets

**Never put a credential in a `.nix` file.** Home Manager renders its generated
dotfiles into `/nix/store`, which is world-readable (mode 0444) and keeps old
generations around long after the line is deleted.

Git credentials go in `~/.config/git/local` — untracked, mode 0600, written by
hand — and are pulled in by `programs.git.includes` in `home/git.nix`. A missing
include file is not an error, so the config stays portable across machines.

```sh
install -m600 /dev/null ~/.config/git/local
```

```ini
[url "https://<user>:<token>@git.example.com"]
    insteadOf = https://git.example.com
```

If a token ever does reach the store, revoke it first — removing the line only
stops it recurring, it does not unpublish it. Then `nix-collect-garbage -d` as
both the user and root.

### gopass and gpg-agent (SSH / headless)

`home/gpg.nix` selects the pinentry by session: a GUI popup when `DISPLAY` /
`WAYLAND_DISPLAY` is set, `pinentry-curses` otherwise. A terminal pinentry
otherwise grabs the TTY an interactive CLI is running in — including a tool that
shells out to `gopass` at startup (e.g. an MCP server) — which freezes that CLI.

The catch over SSH: a **background** process cannot be prompted at all — it has
no interactive terminal to draw a curses prompt on. So prime the passphrase into
the agent cache from your own shell **before** starting anything that reads the
secret:

```sh
export GPG_TTY=$(tty)                     # target the tty pinentry at this shell
gpg-connect-agent updatestartuptty /bye   # point the agent at this TTY
gopass show -o <path/to/secret> >/dev/null # enter passphrase in the curses prompt
# now start the tool that reads the secret — its gopass call hits the cache
```

`maxCacheTtl = 999999` (~11.5 days) keeps it cached, so you re-prime only after a
reboot or `gpgconf --kill gpg-agent`.

**Fully unattended** (cron / CI, no interactive entry) — preset the passphrase:

```nix
# services.gpg-agent in home/gpg.nix
extraConfig = "allow-preset-passphrase";
```

```sh
KG=$(gpg --list-secret-keys --with-keygrip | awk '/Keygrip/{print $3; exit}')
"$(gpgconf --list-dirs libexecdir)/gpg-preset-passphrase" --preset "$KG"  # passphrase on stdin
```

You still supply the passphrase once per agent lifetime; after preset every
decrypt is non-interactive until the agent restarts.

## Home Manager

Wired in as a NixOS module in `flake.nix`:

```nix
home-manager = {
  useGlobalPkgs = true;     # share the system nixpkgs and its config
  useUserPackages = true;   # install to /etc/profiles/per-user/<name>
  extraSpecialArgs = { inherit inputs; };
  users.jakub.imports = [ ./home/home.nix ] ++ lib.optional work ./home/work.nix;
};
```

Consequences worth remembering:

- `nixpkgs.*` may not be set inside the Home Manager modules — the system owns
  it, including `allowUnfree`.
- `home.username` / `home.homeDirectory` are derived from `users.users.<name>`.
- Packages land in `/etc/profiles/per-user/<name>/bin`, **not** `~/.nix-profile/bin`.
  Never hardcode either — interpolate the store path (`"${pkgs.foo}/bin/foo"`).
- There is no separate `home-manager switch`, and no separate generation list.
  User config rolls back with the system.
- `inputs` is available as a module argument in every `home/*.nix`.

### Options

- <https://home-manager-options.extranix.com/>

### User-level systemd services

```nix
# home/systemd.nix
systemd.user.services.foo = {
  Unit.Description = "Foo service";
  Service = {
    Type = "oneshot";
    WorkingDirectory = "/home/jakub/foo-app";
    ExecStart = "/home/jakub/foo-app/foo run";
  };
};

systemd.user.timers.foo = {
  Unit.Description = "Foo timer";
  Timer = {
    OnCalendar = "*-*-* *:00:00";
    Unit = "foo.service";
  };
  Install.WantedBy = [ "timers.target" ];
};
```

### dconf

- <https://github.com/nix-community/dconf2nix>

Dump current desktop settings to Nix:

```sh
dconf dump / | dconf2nix > dconf.nix
```

Requires `programs.dconf.enable = true` on the system side.

### Using unstable packages

`nixpkgs-unstable` is a flake input, instantiated once in `home/home.nix` and
shared with other modules through `_module.args`:

```nix
# home/home.nix
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  _module.args.pkgsUnstable = pkgsUnstable;
}
```

Any module can then take `pkgsUnstable` as an argument:

```nix
{ pkgs, pkgsUnstable, ... }:
{
  home.packages = [ pkgsUnstable.some-package ];
}
```

### Pinning a package to an exact version

Add a dedicated input rather than fetching inline. Find the commit that carries
the version you want (e.g. via <https://www.nixhub.io/>):

```nix
# flake.nix
inputs.nixpkgs-pinned.url = "github:NixOS/nixpkgs/<commit>";
```

```nix
# the consuming module
let
  pinned = import inputs.nixpkgs-pinned {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [ pinned.some-package ];
}
```

The revision is then recorded in `flake.lock` and survives `nix flake update`
unless the URL itself is changed.

### Theme overrides

Use `lib.mkForce` to override a value already set in another imported module:

```nix
# home/ld.nix
programs.helix.settings.theme  = lib.mkForce "catppuccin_latte";
programs.zellij.settings.theme = lib.mkForce "catppuccin-latte";
programs.kitty.themeFile       = lib.mkForce "Catppuccin-Latte";
programs.nixvim.colorschemes.catppuccin.settings.flavour = lib.mkForce "latte";
```

## System

### Mixins

`system/mixins/` holds standalone NixOS modules, imported by a host's
`default.nix`:

| File | Purpose |
|---|---|
| `gnome.nix` | GDM + GNOME, fonts, dconf |
| `gnome-rdp.nix` | GNOME Remote Desktop (RDP), system mode |
| `docker.nix` | Docker (daemon mode) |
| `rootless-docker.nix` | Docker (rootless mode) |
| `containerd.nix` | containerd |
| `virtualbox.nix` | VirtualBox + Extension Pack |
| `libvirt.nix` | libvirtd + virt-manager |
| `kmscon.nix` | kmscon virtual terminals with a Nerd Font |
| `incus.nix` | Incus (LXD fork) with UI |
| `vmware.nix` | VMware Workstation |
| `compose.nix` | generated by compose2nix |
| `i3.nix` | i3 window manager |
| `sway.nix` | Sway (Wayland) |

### SSD

```nix
fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
```

### Zsh

```nix
programs.zsh.enable = true;
users.users.jakub.shell = pkgs.zsh;
```

The interactive configuration (prompt, plugins, aliases) is in
`home/starship.nix`.

### Printing

```nix
services.printing.enable = true;
services.printing.drivers = [
  pkgs.gutenprint
  pkgs.gutenprintBin
  pkgs.canon-cups-ufr2
];

# https://nixos.wiki/wiki/Printing
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};
```

CUPS driver: **IPP Everywhere** — connection: `socket://printer.home`

### Remote Desktop (RDP)

`gnome-rdp.nix` enables GNOME Remote Desktop in system ("remote login") mode on
port 3389. Add it to a host's `imports`; it declaratively enables the service,
generates a self-signed TLS certificate on the host, and turns RDP on — all from
an idempotent activation service, since the upstream NixOS module exposes only
`enable`. Both `e14` and `t440` import it.

Access is **over Tailscale only**: port 3389 is opened solely on the
`tailscale0` interface, never on the LAN or any public interface, so the desktop
is reachable from the tailnet and nowhere else. The tailnet's key-authenticated
WireGuard transport also carries RDP's weak self-signed TLS. This requires the
companion `tailscale.nix` mixin (`services.tailscale.enable` plus the `trayscale`
GUI); after first boot, authenticate the host once:

```bash
sudo tailscale up
```

Then point `remmina` (in `home/packages.nix`) at the host's MagicDNS name or
`100.x` tailnet address on port 3389.

The daemon only accepts `credentials` authentication, so each client must
present a username and password stored on the host. A password cannot live in
the Nix store, so the mixin reads it at activation time from a root-only file
kept out of git:

```bash
sudo install -Dm600 /dev/stdin /etc/gnome-remote-desktop/credentials <<'EOF'
GRD_RDP_USERNAME=jakub
GRD_RDP_PASSWORD=<strong password>
EOF
sudo systemctl restart gnome-remote-desktop-setup.service
```

Connect with that username and password over the tailnet. To rotate the
password, edit the file and restart `gnome-remote-desktop-setup.service`. Note
the password is visible in the systemd journal (`pkexec` logs the `grdctl`
invocation); the tailnet-only exposure keeps that acceptable.

### Virtualisation

#### Rootless Docker

Runs the Docker daemon as the user — no root socket, no `docker` group.
Requires UID/GID sub-ranges and lingering so the daemon survives logout.

```nix
virtualisation.docker.enable = false;

virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;  # sets DOCKER_HOST automatically
};

users.users.jakub = {
  subUidRanges = [{ startUid = 100000; count = 65536; }];
  subGidRanges = [{ startGid = 100000; count = 65536; }];
  linger = true;
};
```

#### VirtualBox

```nix
virtualisation.virtualbox.host.enable = true;
virtualisation.virtualbox.host.enableExtensionPack = true;
users.extraGroups.vboxusers.members = [ "jakub" ];
```

#### libvirt / virt-manager

```nix
virtualisation.libvirtd.enable = true;
programs.virt-manager.enable = true;
users.users.jakub.extraGroups = [ "libvirtd" ];
```

#### Incus

[Incus](https://linuxcontainers.org/incus/) — community fork of LXD.

> **Note:** `networking.nftables.enable = true` is required. Incus uses nftables
> for bridge NAT and fails silently without it.

See `system/mixins/incus.nix` for the full preseed (bridge, profile, storage
pool) and the firewall rules it needs.

## Migrating an existing install

How to move a machine that is still on channels with a standalone
home-manager onto this flake. Nothing here is destructive; the channels stay
as a rollback path until the final step.

**1. Check what the machine is on now.** The revision matters for step 4:

```sh
nixos-version --json          # -> nixpkgsRevision
nix-channel --list
home-manager generations | head -1
```

**2. Bring the machine's own hardware config in.**

```sh
mkdir -p system/hosts/<name>
sudo cp /etc/nixos/hardware-configuration.nix system/hosts/<name>/hardware.nix
$EDITOR system/hosts/<name>/default.nix     # hostname, bootloader, mixins, stateVersion
```

Copy `system.stateVersion` from the old `/etc/nixos/configuration.nix` verbatim
into the host's `default.nix`. **Never bump it during a migration** — it pins
stateful defaults, not the package set, and changing it mid-move conflates two
unrelated things.

`home.stateVersion` lives in `home/home.nix` and is therefore shared by every
host. If the machine being migrated has a different one from what is already
there, do not change the shared value — move it into the host's own
home-manager module instead, or the other machines silently get a new one.

**3. Register the host** in `flake.nix` (`<name> = mkHost { name = "<name>"; };`), then
`git add` everything. Untracked files are invisible to the flake.

**4. Optional but recommended for the first build: pin `nixpkgs` to the
revision the machine is already running.** Every store path then matches what
is already there, so the first build is minutes rather than a full download,
and any breakage is attributable to the restructuring rather than to a package
bump:

```nix
# flake.nix — temporarily
nixpkgs.url = "github:NixOS/nixpkgs/<nixpkgsRevision from step 1>";
```

**5. Dry-run it.**

```sh
nix flake check
nixos-rebuild build --flake .#<name>
```

Common failures at this point, all from home-manager moving into the system
config: `nixpkgs.*` being set inside a home-manager module (the system owns it
under `useGlobalPkgs`), `home.username`/`homeDirectory` still declared, or a
hardcoded `~/.nix-profile/bin/...` path (packages are in
`/etc/profiles/per-user/<name>/bin` under `useUserPackages` — interpolate the
store path instead).

**6. Try it in a VM first.** `nixos-rebuild build-vm --flake .#vm` exercises the
shared config and the home-manager modules without touching the machine.

**7. Switch.**

```sh
sudo nixos-rebuild switch --flake .#<name>
```

Reboot and confirm the desktop, then `systemctl --failed`.

**8. Retire the old setup** — only after a successful reboot, and rename rather
than delete for one rollback cycle:

```sh
home-manager expire-generations '-0 days'     # standalone HM is gone now
sudo mv /etc/nixos /etc/nixos.pre-flake
mv ~/.config/home-manager ~/.config/home-manager.pre-flake
```

Keep the channels registered until you are confident, then:

```sh
nix-channel --remove home-manager
nix-channel --remove nixpkgs-unstable
sudo nix-channel --remove nixos
```

**9. Unpin `nixpkgs`** (undo step 4) and rebuild. This is the first build that
actually changes package versions, and it is now the only variable.

If anything goes wrong at any point: `sudo nixos-rebuild --rollback`, or pick
the previous generation from the boot menu. The pre-flake system generation
remains bootable until it is garbage-collected.

## Bootstrapping a new machine

```sh
nix-shell -p git
git clone <this repo> ~/Repos/nixos-config
cd ~/Repos/nixos-config

# create the host
mkdir -p system/hosts/<name>
sudo nixos-generate-config --show-hardware-config > system/hosts/<name>/hardware.nix
$EDITOR system/hosts/<name>/default.nix   # hostname, bootloader, mixins, stateVersion
$EDITOR flake.nix                         # <name> = mkHost { name = "<name>"; };
git add system/hosts/<name> flake.nix

sudo nixos-rebuild switch --flake .#<name>
```

Flakes must already be enabled to build a flake — on a stock installer, add
`--extra-experimental-features 'nix-command flakes'` to that last command. The
config itself sets it permanently:

```nix
nix.settings.experimental-features = "nix-command flakes";
```

Afterwards, write `~/.config/git/local` as described under [Secrets](#secrets).

## Cachix

```sh
sudo cachix use nix-community
```

Caches are declared in `system/cachix.nix` and `system/cachix/`. The
`llm-agents` binary cache is configured in `system/common.nix`:

```nix
nix.settings = {
  extra-substituters = [ "https://cache.numtide.com" ];
  extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];
};
```

## Reference Docs

[`docs/`](docs/) contains notes on configs not currently in use (i3, Sway, Zsh
variants).

### Useful aliases

Defined in `home/starship.nix`:

| Alias | Command |
|---|---|
| `update-nixos` | rebuild and switch from this flake |
| `upgrade-nixos` | `nix flake update` then rebuild and switch |
| `gc-nixos` | `sudo nix-collect-garbage --delete-older-than 15d` |
| `git-wt-switch` | fzf over `git worktree list`, cd to selection |
| `git-branch-switch` | fzf over `git branch`, checkout selection |
| `k` | `kubectl` |
| `e` | `nvim` |

Ansible helper — bump a package version across all `*.yml`/`*.yaml` files:

```zsh
update-ansible-pkg-version <package-name> <new-version>
```
