# NixOS Configuration

## Table of Contents

- [SSD](#ssd)
- [Zsh](#zsh)
- [Printing](#printing)
- [Garbage Collection](#garbage-collection)
- [Virtualisation](#virtualisation)
  - [Rootless Docker](#rootless-docker)
  - [VirtualBox](#virtualbox)
  - [libvirt / virt-manager](#libvirt--virt-manager)
  - [Incus](#incus)
- [Cinnamon](#cinnamon)
- [Mixins](#mixins)
- [Home Manager](#home-manager)
  - [Options](#options)
  - [Setup](#setup)
  - [User-level systemd services](#user-level-systemd-services)
  - [dconf](#dconf)
  - [Using llm-agents.nix](#using-llm-agentsnix)
  - [Using unstable packages](#using-unstable-packages)
- [Upgrade Notes](#upgrade-notes)
- [Cachix](#cachix)
- [Theme Overrides](#theme-overrides)
- [Reference Docs](#reference-docs)

______________________________________________________________________

## SSD

```nix
# /etc/nixos/configuration.nix
fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
```

## Zsh

```nix
# /etc/nixos/configuration.nix
programs.zsh.enable = true;
users.users.jakub.shell = pkgs.zsh;
```

## Printing

```nix
# /etc/nixos/configuration.nix
services.printing.enable = true;
services.printing.drivers = [
  pkgs.gutenprint
  pkgs.gutenprintBin
  pkgs.canon-cups-ufr2
];

# https://nixos.wiki/wiki/Printing
services.avahi = {
  enable = true;
  nssmdns = true;
  openFirewall = true;
};
```

CUPS driver: **IPP Everywhere** — connection: `socket://printer.home`

## Garbage Collection

```nix
# /etc/nixos/configuration.nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 15d";
};
```

Manual collection:

```sh
nix-store --gc
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

______________________________________________________________________

## Virtualisation

### Rootless Docker

Runs the Docker daemon as the user — no root socket, no `docker` group needed.
Requires UID/GID sub-ranges and lingering so the daemon survives logout.

```nix
# mixins/rootless-docker.nix
virtualisation.docker.enable = false;

virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;  # sets DOCKER_HOST automatically
};

users.users.jakub = {
  subUidRanges = [{ startUid = 100000; count = 65536; }];
  subGidRanges = [{ startGid = 100000; count = 65536; }];
  linger = true;  # daemon survives user logout
};
```

### VirtualBox

```nix
# mixins/virtualbox.nix
virtualisation.virtualbox.host.enable = true;
virtualisation.virtualbox.host.enableExtensionPack = true;
users.extraGroups.vboxusers.members = [ "jakub" ];
```

### libvirt / virt-manager

```nix
# mixins/libvirt.nix
virtualisation.libvirtd.enable = true;
programs.virt-manager.enable = true;
users.users.jakub.extraGroups = [ "libvirtd" ];
```

### Incus

[Incus](https://linuxcontainers.org/incus/) — community fork of LXD.

> **Note:** `networking.nftables.enable = true` is required. Incus uses nftables for bridge NAT and fails silently without it.

```nix
# mixins/incus.nix
virtualisation.incus = {
  enable = true;
  ui.enable = true;
};

virtualisation.incus.preseed = {
  networks = [{
    name = "incusbr0";
    type = "bridge";
    config = {
      "ipv4.address" = "10.0.100.1/24";
      "ipv4.nat"     = "true";
    };
  }];
  profiles = [{
    name = "default";
    devices = {
      eth0 = { name = "eth0"; network = "incusbr0"; type = "nic"; };
      root = { path = "/"; pool = "default"; size = "10GiB"; type = "disk"; };
    };
  }];
  storage_pools = [{
    name   = "default";
    driver = "dir";
    config = { source = "/var/lib/incus/storage-pools/default"; };
  }];
};

networking.nftables.enable = true;
networking.firewall.trustedInterfaces = [ "incusbr0" ];
networking.firewall.interfaces.incusbr0.allowedUDPPorts = [ 53 67 ];
networking.firewall.interfaces.incusbr0.allowedTCPPorts  = [ 53 67 ];

users.extraGroups.incus-admin.members = [ "jakub" ];
```

______________________________________________________________________

## Cinnamon

```nix
# /etc/nixos/configuration.nix
services.xserver.displayManager.lightdm.enable = true;
services.xserver.displayManager.defaultSession = "cinnamon";
services.xserver.desktopManager.cinnamon.enable = true;
programs.dconf.enable = true;
```

Desktop settings (themes, cursor, power, etc.) are managed via `home-manager/cinnamon.nix` using dconf.

______________________________________________________________________

## Mixins

`mixins/` contains standalone NixOS modules to drop into any machine config:

| File | Purpose |
|------------------------------|-----------------------------|
| `mixins/rootless-docker.nix` | Docker (rootless mode) |
| `mixins/virtualbox.nix` | VirtualBox + Extension Pack |
| `mixins/libvirt.nix` | libvirtd + virt-manager |
| `mixins/incus.nix` | Incus (LXD fork) with UI |
| `mixins/containerd.nix` | containerd |
| `mixins/docker.nix` | Docker (daemon mode) |
| `mixins/vmware.nix` | VMware Workstation |
| `mixins/i3.nix` | i3 window manager |
| `mixins/sway.nix` | Sway (Wayland) |

Import in your system config:

```nix
# /etc/nixos/configuration.nix
imports = [
  ./hardware-configuration.nix
  ./mixins/rootless-docker.nix
  ./mixins/virtualbox.nix
  ./mixins/libvirt.nix
];
```

______________________________________________________________________

## Home Manager

### Options

- <https://home-manager-options.extranix.com/>

### Setup

**1. Allow home-manager users**

```nix
# /etc/nixos/configuration.nix
nix.settings = {
  experimental-features = "nix-command flakes";
  auto-optimise-store = true;
  allowed-users = [ "@wheel" ];
};
```

**2. Add channel**

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
```

**3. Install**

```sh
nix-shell '<home-manager>' -A install
```

**4. Use this config**

```sh
nix-shell -p git vim
git clone https://github.com/jakubvokoun/nixos-config
cd nixos-config
cp -f home-manager/*.nix ~/.config/home-manager/
vim ~/.config/home-manager/home.nix
home-manager switch
```

### User-level systemd services

```nix
# ~/.config/home-manager/home.nix
imports = [ ./systemd.nix ];
```

```nix
# ~/.config/home-manager/systemd.nix
systemd.user.services.foo = {
  Unit.Description = "Foo service";
  Service = {
    Type = "oneshot";
    WorkingDirectory = "/home/jakub/foo-app";
    ExecStart = "/home/jakub/Work/foo-app/foo run";
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

### Using llm-agents.nix

- <https://github.com/numtide/llm-agents.nix>

```nix
# ~/.config/home-manager/home.nix
{ inputs, lib, config, pkgs, ... }:
let llm-agents = builtins.getFlake "github:numtide/llm-agents.nix";
in {
  nixpkgs.overlays = [ llm-agents.overlays.default ];

  home.packages = with pkgs; [
    pkgs.llm-agents.claude-code
    pkgs.llm-agents.opencode
    pkgs.llm-agents.openspec
  ];
}
```

Cache setup (add to system config):

```nix
# /etc/nixos/configuration.nix
nix.settings = {
  extra-substituters = [ "https://cache.numtide.com" ];
  extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];
};
```

### Using unstable packages

```sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --update
```

```nix
# ~/.config/home-manager/home.nix
{ inputs, lib, config, pkgs, ... }:
let pkgsUnstable = import <nixpkgs-unstable> { };
in {
  home.packages = [ pkgsUnstable.claude-code ];
}
```

______________________________________________________________________

## Upgrade Notes

### System

```sh
sudo nix-channel --add https://nixos.org/channels/nixos-25.11 nixos
sudo nix-channel --update
sudo nixos-rebuild boot --upgrade
```

### Home Manager

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
home-manager build
home-manager switch
```

______________________________________________________________________

## Cachix

```sh
sudo cachix use nix-community
```

```nix
# /etc/nixos/configuration.nix
imports = [ ./cachix.nix ];
```

______________________________________________________________________

## Theme Overrides

Use `lib.mkForce` to override a value already set in another imported module:

```nix
# home-manager/ld.nix
programs.helix.settings.theme  = lib.mkForce "catppuccin_latte";
programs.zellij.settings.theme = lib.mkForce "catppuccin-latte";
programs.kitty.themeFile        = lib.mkForce "Catppuccin-Latte";
programs.nixvim.colorschemes    = lib.mkForce {
  tokyonight.enable = false;
  catppuccin = {
    enable = true;
    settings.flavour = "latte";
  };
};
```

______________________________________________________________________

## Reference Docs

[`docs/`](docs/) contains notes on unused configs (i3, Sway, Zsh variants).

### Useful aliases

| Alias | Command |
|---|---|
| `update-nixos` | `sudo nix-channel --update && sudo nixos-rebuild switch` |
| `update-home` | `sudo nix-channel --update && home-manager switch` |
| `gc-nixos` | `sudo nix-collect-garbage --delete-older-than 15d` |
| `gc-home` | `home-manager expire-generations '-15 days'` |
| `git-wt-switch` | fzf over `git worktree list`, cd to selection |
| `git-branch-switch` | fzf over `git branch`, checkout selection |

Ansible helper — bump a package version across all `*.yml`/`*.yaml` files:

```zsh
update-ansible-pkg-version <package-name> <new-version>
```
