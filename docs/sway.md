# Sway config (unused)

Wayland compositor config. Source: `sway.nix` (+ `mako.nix`, `waybar.nix`, `wlogout.nix`, `wlsunset.nix` via `default.nix`).

## Base

- **Modifier:** `Mod4` (Super)
- **Terminal:** `kitty`
- **Font:** DejaVu Sans Mono 10pt
- **Bar:** `waybar`
- **GTK wrapper:** enabled (`wrapperFeatures.gtk = true`)
- **systemd integration:** enabled

## Keyboard

Czech layout: `xkb_layout "cz"` (set in `input type:keyboard`).

## Startup

| Command | Notes |
|---|---|
| `waypaper --restore` | Restore wallpaper |
| `nm-applet` | Network tray |
| `sleep 5; systemctl --user start kanshi.service` | 5s delay before kanshi (monitor layout service) — workaround for race condition at boot |

`SSH_AUTH_SOCK` forced to `/run/user/1000/keyring/ssh` via zsh `sessionVariables`.
`services.gnome-keyring.enable = true`

## Keybindings

| Key | Action |
|---|---|
| `Mod4+m` | Move workspace to output left |
| `Mod4+Shift+m` | Move workspace to output right |
| `Mod1+Space` | `rofi -show drun` |
| `Mod1+Tab` | `rofi -modi combi -combi-modi window` |
| `Mod4+Shift+x` | `wlogout` (logout menu) |
| `XF86AudioRaiseVolume` | `pactl set-sink-volume @DEFAULT_SINK@ +5%` |
| `XF86AudioLowerVolume` | `pactl set-sink-volume @DEFAULT_SINK@ -5%` |
| `XF86AudioMute` | Toggle sink mute |
| `XF86AudioMicMute` | Toggle source mute |
| `XF86MonBrightnessDown` | `brightnessctl set 5%-` |
| `XF86MonBrightnessUp` | `brightnessctl set 5%+` |

## Idle / lock (swayidle)

| Timeout | Action |
|---|---|
| 295s | `notify-send 'Locking in 5 seconds' -t 5000` |
| 300s | `swaylock` |
| 360s | `swaymsg 'output * dpms off'` (resume: dpms on) |
| before-sleep event | `swaylock` |

5-second warning before lock is intentional — gives time to abort. DPMS kicks in 60s after lock.

**swaylock settings:** `daemonize = true`, `ignore-empty-password = true`

## Packages

`swaybg`, `waypaper`, `wdisplays`, `grim`, `slurp`, `wl-clipboard`, `mako`, `libnotify`, `pavucontrol`, `xfce.thunar` + `thunar-volman` + `ristretto`, `nemo`, `networkmanagerapplet`

## Other wayland/ files

- **`waybar.nix`** — 26-module status bar (workspaces, clock, network, bluetooth, pulseaudio, backlight, cpu, memory, battery, tray). No custom CSS (TODO).
- **`mako.nix`** — Notification daemon: 4.5s timeout, `ignore-timeout = true`.
- **`wlogout.nix`** — Logout menu with keybinds: lock/hibernate/logout/shutdown/suspend/reboot.
- **`wlsunset.nix`** — Night light. Prague coords: `50.073658, 14.418540`. Day 5800K → night 3500K. Update coords if location changes.
- **`rofi.nix`** — Rofi with wayland variant enabled.
