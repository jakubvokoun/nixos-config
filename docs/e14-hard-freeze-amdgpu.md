# Task: e14 hard freezes / spontaneous restarts

The e14 (ThinkPad E14 Gen 3, Ryzen Renoir APU, `amdgpu`) regularly freezes hard and has to be power-cycled. Suspected OOM; investigated from the systemd journal on 2026-10-14.

## Verdict

**Not OOM. The machine hard-hangs with nothing written to the journal or pstore. Prime suspect is the amdgpu display engine (DMCUB firmware / PSR), not proven.** Fix order: BIOS update, then disable PSR, then `sg_display=0`.

## Findings (e14, 2026-10-14)

- `last -x` shows 24 `crash` entries since 2024-01. Crashed boots still in the journal end on 2026-06-02, 08-13, 09-30, 10-01, 10-14.
- No OOM in any crashed boot: no `oom-kill` / `Killed process`, `earlyoom` never acted. Last sample before the 10-14 crash (14:41): `mem avail: 5318 of 11774 MiB (45.17%), swap free: 11362 of 16296 MiB`.
- Every crashed boot ends abruptly mid-stream (10-14: 14:48:23, Chrome WebRTC spam). No shutdown sequence, no panic, no hung-task / soft-lockup, no new `/var/lib/systemd/pstore/` entry.
- Kernel-independent: crashes on 6.12.67, 6.12.74, 6.12.90, 6.18.38, 6.18.52, 6.18.55.
- Every crashed boot carries `amdgpu 0000:04:00.0: [drm] *ERROR* dc_dmub_srv_log_diagnostic_data: DMCUB error - collecting diagnostic data` (16-104 per boot), and each crash comes hours after a resume from `deep` sleep.
- DMCUB errors also appear in cleanly shut-down boots (0-53 per boot), so they mark an unhealthy display firmware but do not by themselves prove causation.
- 2026-10-12 21:08: `WARNING ... dcn21_link_encoder_acquire_phy` via `dp_handle_link_loss` during a USB dock disconnect (DP MST link loss).
- BIOS `R1OET28W (1.07)` from 2021-07; DMUB firmware `0x0101002B`; no `amdgpu.*` kernel params set.

## Fix steps

1. BIOS update (Lenovo shipped many newer E14 Gen 3 releases with Renoir power/display fixes):

   ```
   fwupdmgr refresh && fwupdmgr get-updates
   ```

   Fallback: Lenovo bootable BIOS update ISO.

2. Disable Panel Self Refresh (PSR runs on DMCUB). Guess, not verified on this box; costs a little idle power:

   ```nix
   boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
   ```

3. Still freezing: add `amdgpu.sg_display=0` (known Renoir/Cezanne stability workaround).

## Capture evidence on the next hang

```nix
boot.kernelParams = [ "ramoops.mem_size=0x100000" ];  # panic trace survives reset -> /var/lib/systemd/pstore/
systemd.watchdog.runtimeTime = "30s";                  # sp5100_tco reboots a hung box; not a fix
```

`netconsole` to another host is the alternative to ramoops.

## Verify

- After step 2: `journalctl -k -b | grep DMCUB` should go quiet.
- Crash cadence was 1-6 weeks, so confirm via `last -x | grep crash` over a few weeks.
- Re-profile crashed boots:

  ```sh
  journalctl --list-boots --no-pager -q | awk '{print $1}' | while read b; do
    [ "$b" = 0 ] && continue
    journalctl -b $b -n 30 --no-pager -q | grep -qE 'Journal stopped|systemd-shutdown' && continue
    echo "boot $b end=$(journalctl -b $b -n 1 --no-pager -q -o short-iso | cut -c1-19) DMCUB=$(journalctl -b $b -k --no-pager -q | grep -c 'DMCUB error')"
  done
  ```
