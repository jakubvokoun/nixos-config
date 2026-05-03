# Zsh configs (unused)

Two variants: `zsh-powerline-go.nix` (powerline-go prompt) and `zsh-minimal.nix` (hand-rolled prompt). Both share the same aliases and base setup.

## Common base

**Packages:** `batman` (bat-based man page reader, activated via `eval "$(batman --export-env)"`)

**Plugins:**

- `zsh-nix-shell` (chisui/zsh-nix-shell v0.8.0) — keeps nix-shell as zsh instead of dropping to bash

**Completions:** case-insensitive (`m:{a-zA-Z}={A-Za-z}`), menu select

**Integrations:** zoxide, carapace

**Session variables:**

```
EDITOR / VISUAL = nvim
NIXPKGS_ALLOW_INSECURE = 1
NIXPKGS_ALLOW_UNFREE = 1
TERM = xterm-256color
XCURSOR_THEME = Bibata-Modern-Classic / XCURSOR_SIZE = 24
```

**Aliases:**
| Alias | Command |
|---|---|
| `e` | `nvim` |
| `update-nixos` | `sudo nix-channel --update && sudo nixos-rebuild switch` |
| `update-home` | `sudo nix-channel --update && home-manager switch` |
| `gc-nixos` | `sudo nix-collect-garbage --delete-older-than 15d` |
| `gc-home` | `home-manager expire-generations '-15 days'` |
| `git-wt-switch` | fzf over `git worktree list`, cd to selection |
| `git-branch-switch` | fzf over `git branch`, checkout selection |

**Ansible helper function** (both files):

```zsh
update-ansible-pkg-version <package-name> <new-version>
```

Recursively finds all `*.yml`/`*.yaml` files containing `- <package-name>=...` and replaces the version in-place via `grep -r -l | xargs sed -i`.

## zsh-powerline-go.nix

Uses `programs.powerline-go` with two-line prompt (newline = true).

**Modules (left):** aws, docker, venv, nix-shell, kube, terraform-workspace, ssh, cwd, perms, git, hg, jobs, exit, root

**Settings:**

- `hostname-only-if-ssh = true`
- `numeric-exit-codes = true`
- `cwd-max-depth = 2`

## zsh-minimal.nix

No powerline-go. Hand-rolled prompt functions, no external dependencies beyond zsh itself.

**Prompt functions:**

`git_prompt()` — shows `[branch*+?]` where:

- `*` = unstaged changes
- `+` = staged changes
- `?` = untracked files
- yellow when dirty, green when clean

`venv_prompt()` — shows `(venv-name)` when `$VIRTUAL_ENV` set

`aws_prompt()` — shows `[aws:PROFILE]`, prefers `$AWS_VAULT` over `$AWS_PROFILE`

`nix_prompt()` — shows `[nix:NAME]` or `[nix-shell]` when `$IN_NIX_SHELL` set

**Prompt format:**

```
%F{blue}%3~%f<git> <venv> <aws> <nix>
[exit-code if nonzero] ❯
```

**Extra session variables** (minimal only):

```
AWS_VAULT_PROMPT = terminal
VIRTUAL_ENV_DISABLE_PROMPT = 1
```
