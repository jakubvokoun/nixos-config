# AGENTS.md

Single flake: NixOS + Home Manager (as a NixOS module) for hosts `e14`, `t440`, `vm`.
`README.md` is the full manual - read the relevant section before changing an area
(hosts, mixins, secrets, Home Manager, Podman, OpenShell, updates).

## Verify a change

Evaluate every host the change can reach. Evaluation catches option and type errors in ~30 s per host:

```sh
nix eval --raw .#nixosConfigurations.e14.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.t440.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.vm.config.system.build.toplevel.drvPath
```

For a change to a derivation (`system/packages/`, `home/packages/`), build it:
`nixos-rebuild build --flake .#e14`. Run `sudo nixos-rebuild switch` only when the user asks.

Format with `nixfmt` (RFC style). `system/cachix/*.nix` are generated - leave them as they are.

## Gotchas

- The flake reads the git tree. A new file is invisible until `git add`; the error is `... does not exist`.
- `home/` is shared by every host; `home/work.nix` loads only where `mkHost { work = true; }` (default). `t440` has `work = false`.
- `system/vm-guest.nix` applies to every host, but only under `virtualisation.vmVariant`.
- Home Manager runs with `useGlobalPkgs`: set `nixpkgs.*` (incl. `allowUnfree`) on the system side only.
- Unstable packages: take `pkgsUnstable` as a module argument (set in `home/home.nix`). Do not import `nixpkgs-unstable` again.
- Every source is pinned: use `pkgs.fetchFromGitHub` with a hash or a flake input. `<nixpkgs>`, `builtins.fetchGit` and `fetchTarball` break this.
- Keep `system.stateVersion` and `home.stateVersion` at their current values, also during a release upgrade.
- `system/hosts/*/hardware.nix` holds machine UUIDs. Edit it only for a disk or hardware change on that host.
- Credentials stay outside `.nix` files: the store is world-readable. Use untracked files (`~/.config/git/local`, `*.local.nix`, root-only files read at activation).
- `podman.nix` conflicts with `docker.nix` and `rootless-docker.nix` (all provide `docker`).
- `docs/` describes configs that are not in use.

## Conventions

- System feature = one module in `system/mixins/`, imported from `system/hosts/<name>/default.nix`.
- User program = one module in `home/`, imported from `home/home.nix`.
- Locally packaged software: `system/packages/` or `home/packages/`, `callPackage`d by the consuming module.
- Commits: Conventional Commits (`feat:`, `chore:`, `docs:`). Commit `flake.lock` with every input update.
- Document a new mixin or host in the matching `README.md` table.
