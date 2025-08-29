# NixOS Configuration

## SSD

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...

  # If you are using an SSD it may be useful to enable TRIM support as well as set filesystem flags to improve the SSD performance:
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

}
```

## Zsh

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...

  # Zsh
  programs.zsh.enable = true;
  users.users.jakub.shell = pkgs.zsh;
}
```

## Docker

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "jakub" ];
}
```

## Virtualbox

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jakub" ];
}
```

## Printing

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...

  # Enable CUPS to print documents.
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
}
```

### CUPS

- driver: IPP Everywhere 
- connection: socket://printer.home

### i3

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # Xfce
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "none+i3";

  # i3
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.xserver.windowManager.i3.enable = true;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
}
```

### Garbage collection

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
}
```

```sh
nix-store --gc
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## Home manager

### Options

- https://home-manager-options.extranix.com/

### Set `nix.settings.allowed-users`

```nix
# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ...

  # Nix settings
  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # Allowed users - needed for Home manager
    allowed-users = [ "@wheel" ];
  };
}

```

### Add channel

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update
```

### Install Home manager

```sh
nix-shell '<home-manager>' -A install
```

### Use my config

```sh
nix-shell -p git vim
git clone https://github.com/jakubvokoun/nixos-config
cd nixos-config
cp -f home-manager/*.nix ~/.config/home-manager/
vim ~/.config/home-manager/home.nix
home-manager switch
```

### Mininal config

Taken from: https://github.com/Misterio77/nix-starter-configs

### User-level systemd services

```nix
# ~/.config/home-manager/home.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # ...
    ./systemd.nix
  ];
}
```

```nix
# ~/.config/home-manager/systemd.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  systemd.user.services.foo = {
    Unit = { Description = "Foo service"; };

    Service = {
      Type = "oneshot";
      WorkingDirectory = "/home/jakub/foo-app";
      ExecStart = "/home/jakub/Work/foo-app/foo run";
    };
  };

  systemd.user.timers.foo = {
    Unit = { Description = "Foo timer"; };

    Timer = {
      OnCalendar = "*-*-* *:00:00";
      Unit = "foo.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
```

### `dconf`

- https://github.com/nix-community/dconf2nix

```sh
dconf dump / | dconf2nix > dconf.nix
```
