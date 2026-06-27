---
name: nixosdots-maintainer
description: |
  How to safely maintain, debug, and fix the nixosdots NixOS flake configuration
  at ~/Dots/nixosdots. Use this skill whenever the user mentions nixosdots, NixOS
  rebuild errors, nix flake issues, home-manager errors, nixpkgs version mismatches,
  "dry-build", "dry-run", flake.lock problems, nixos-rebuild, package removal/renaming
  in nixpkgs, or wants to modify/fix/debug their NixOS configuration. Also use it when
  the user pastes nix build errors, evaluation errors, or rebuild failures — even if
  they don't explicitly name nixosdots. This skill enforces safe iteration via dry-run
  validation and forbids unauthorized system switches.
---

# nixosdots-maintainer

A skill for maintaining the `~/Dots/nixosdots` NixOS flake configuration safely.
The core principle: **always validate with dry-run before any change, never switch
the system without explicit user consent.**

## The One Iron Rule

**NEVER run `nixos-rebuild switch` or `nixos-rebuild test` on your own.** These
commands activate a new system generation — they're the user's decision. Your job
is to fix the configuration and prove it evaluates cleanly via `dry-build`. The
user runs `switch` themselves when satisfied.

If you find yourself about to type `sudo nixos-rebuild switch`, stop. You're
violating the rule. Switch to `dry-build` instead.

## Repository Layout

```
~/Dots/nixosdots/
├── flake.nix              # All inputs + 4 host outputs (desktop, laptop, wsl, vm)
├── flake.lock            # Pinned input versions (NEVER hand-edit JSON formatting)
├── hosts/                # Per-host config: default.nix + hardware + addon
│   ├── desktop/          #   Full desktop (default.full.nix)
│   ├── laptop/           #   Full laptop
│   ├── vm/               #   Minimal VM (default.mini.nix) ← user's primary dev target
│   └── wsl/              #   WSL (nixos-wsl module + default.mini.nix)
├── modules/
│   ├── default.full.nix  # Full profile: imports ~23 modules
│   ├── default.mini.nix  # Minimal profile: imports ~8 modules
│   ├── programs/         # nvim.nix, git.nix, kitty.nix, zsh.nix, packages.*.nix...
│   ├── system/           # hyprland/, waybar/, rofi.nix, fcitx5.nix...
│   └── themes/           # stylix/ (active), catppuccin/ (alternative)
├── nixos/
│   ├── variables.nix     # config.var.{username,hostname,timeZone,catppuccin.flavor...}
│   ├── home-manager.nix  # home-manager integration (extraSpecialArgs = {inherit inputs})
│   └── base.nix          # base system config
├── assets/               # wallpapers, static files (kept in-repo, not flake inputs)
├── pkgs/                 # custom nix packages
└── scripts/              # first_install.sh, net_set.sh
```

### Key conventions

- **Variables**: `config.var.username`, `config.var.catppuccin.flavor`, etc. defined in `nixos/variables.nix`. Reference these instead of hardcoding.
- **Profiles**: `default.full.nix` (desktop/laptop) vs `default.mini.nix` (vm/wsl). Home Manager user imports one of these.
- **Home Manager**: integrated via `nixos/home-manager.nix` with `extraSpecialArgs = { inherit inputs }`, so modules receive `inputs` as a parameter.
- **dotfiles input**: `inputs.dotfiles.packages.${system}.nvim-config` provides the nvim config (from the `gagapony/dotfiles` repo), symlinked into `~/.config/nvim` via `xdg.configFile`.

## Build commands

| Goal | Command | Needs sudo? |
|---|---|---|
| **Eval check (your primary tool)** | `cd ~/Dots/nixosdots && nixos-rebuild dry-build --flake .#vm` | No |
| **Switch system (USER ONLY)** | `sudo nixos-rebuild switch --flake .#vm` | Yes |
| **Update single input** | `cd ~/Dots/nixosdots && nix flake update nixpkgs` | No |
| **Update all inputs** | `cd ~/Dots/nixosdots && nix flake update` | No |
| **Rollback (USER ONLY)** | `sudo nixos-rebuild rollback` | Yes |

The user's primary host is `vm`. If they don't specify a host, default to `.#vm`.

`dry-build` evaluates the full configuration (NixOS system + home-manager) and
lists what would be built/fetched, but downloads nothing and changes nothing. It
catches all evaluation errors — the kind you're fixing — typically in 1-3 minutes.
This is your verification loop.

## Dependency investigation

When the user asks "why is X being installed" or "what pulled in package Y", or
when `dry-build` shows an unexpected package in the closure, use `nix why-depends`
to trace the dependency chain. This works on derivations (`.drv`) — give it the
toplevel of the host config and the store path of the package you're questioning:

```bash
cd ~/Dots/nixosdots && nix why-depends --derivation \
    .#nixosConfigurations.vm.config.system.build.toplevel \
    /nix/store/<hash>-<package>-<version>.drv
```

Example — tracing why inkscape ends up in the VM build:
```bash
nix why-depends --derivation \
    .#nixosConfigurations.vm.config.system.build.toplevel \
    /nix/store/rlvwbxw010mws3ldfyh82fpjcypirrv6-inkscape-1.4.4.drv
```

The output is a chain showing each hop from the system toplevel down to the
target package. Read it top-to-bottom to find the *first* link you control (a
package in `home.packages`, a module import, a stylix target, etc.) — that's
where to cut the dependency if you want to remove it.

Tips:
- Swap the host (`.#desktop`, `.#laptop`, etc.) to check a different config.
- If you only have the package *name* (not the store path), find its derivation
  first: `nix eval --raw nixpkgs#<name>.drvPath 2>/dev/null` or look it up in the
  `dry-build` output log (`/tmp/nixdry.log`).
- `nix why-depends` without `--derivation` traces the runtime closure (installed
  paths); with `--derivation` it traces the build-time dependency graph, which is
  what matters for "why is the build pulling this in" questions.

## The fix-then-validate workflow

For any configuration change, follow this exact loop:

### 1. Reproduce the error

Run `dry-build` to see the current error and confirm you can reproduce it:
```bash
cd ~/Dots/nixosdots && nixos-rebuild dry-build --flake .#vm > /tmp/nixdry.log 2>&1; echo "EXIT=$?"
grep -A3 "^error:" /tmp/nixdry.log | head -40
```

### 2. Read the error carefully

Nix errors are verbose but informative. The key parts:
- **`error: <message>`** — the actual problem (e.g. "nodePackages has been removed")
- **`while evaluating the option X`** — traces which config option triggers it
- **`while evaluating definitions from <file>`** — points to the source file

Common patterns and their meanings:

| Error | Root cause | Fix pattern |
|---|---|---|
| `nodePackages has been removed` | nixpkgs moved pkg to top-level | `nodePackages.prettier` → `prettier` |
| `option 'plugins.X.runtime' does not exist` | home-manager / nixpkgs version mismatch | update both: `nix flake update` (full, not single input) |
| `attribute 'X' missing` | package renamed/removed in nixpkgs | search search.nixos.org for new name |
| `The option X does not exist` | module schema changed | check home-manager/nixpkgs changelog for that module |
| `hash mismatch` | upstream tarball changed | `nix flake update --impure <input>` or update lock |
| `infinite recursion encountered` | config cycle | usually a `mkDefault`/override conflict |

### 3. Make the minimal fix

Edit the specific file the error points to. Change one thing at a time.
Don't refactor "while you're here" — that obscures what fixed the issue.

### 4. Re-run dry-build to confirm

```bash
cd ~/Dots/nixosdots && nixos-rebuild dry-build --flake .#vm > /tmp/nixdry.log 2>&1; echo "EXIT=$?"
echo "errors: $(grep -c '^error:' /tmp/nixdry.log)"
```

**EXIT=0 and errors=0 means the configuration evaluates cleanly.** At that point,
tell the user: "eval passes, you can switch when ready" — and stop. Do not switch.

If there's a new error, go back to step 2. Iterate until clean.

### 5. Report to user

After eval passes, summarize:
- What was broken (the root cause)
- What you changed (file + the specific edit)
- That dry-build passes (EXIT=0, 0 errors)
- Any remaining warnings (deprecation warnings are OK — they don't break the build)
- The command for the user to switch themselves

## Flake input management — the version-mismatch trap

This is the single most common source of breakage in this repo.

**The trap**: Running `nix flake update nixpkgs` (single input) upgrades nixpkgs
but leaves home-manager, nixvim, and other `follows = "nixpkgs"` inputs at their
old commits. Their **code** expects the old nixpkgs API. Result: cryptic schema
errors like `option 'plugins.X.runtime' does not exist`.

**The fix**: When updating nixpkgs, always update ALL inputs together:
```bash
cd ~/Dots/nixosdots && nix flake update
```

This keeps home-manager / nixvim / stylix / etc. aligned with the new nixpkgs.

**Why `follows` doesn't save you**: `inputs.nixpkgs.follows = "nixpkgs"` means
home-manager *uses* the root nixpkgs, but home-manager's *own source code* (its
commit) doesn't change. You need to update the home-manager input itself so its
code matches the new nixpkgs APIs.

### Detecting the trap

If you see `dry-build` errors involving `option does not exist` or `schema`
after a flake update, check if inputs are version-aligned:
```bash
python3 -c "
import json, datetime
lock = json.load(open('$HOME/Dots/nixosdots/flake.lock'))
root = lock['nodes']['root']['inputs']
for name in ['nixpkgs','home-manager','nixvim','stylix']:
    node = root.get(name)
    if node and node in lock['nodes'] and 'locked' in lock['nodes'][node]:
        n = lock['nodes'][node]['locked']
        d = datetime.datetime.fromtimestamp(n['lastModified'], tz=datetime.timezone.utc).strftime('%Y-%m-%d')
        print(f'{name}: {d}')
"
```
If nixpkgs is months newer than home-manager/nixvim, that's the trap. Fix with
full `nix flake update`.

## flake.lock editing

**Never hand-edit flake.lock JSON.** Its format (key ordering, whitespace) is
generated by nix — manual edits create massive unreadable diffs and can corrupt
the lock.

To remove an input from flake.lock:
1. Delete it from `flake.nix` `inputs` block
2. Run `nix flake lock` (nix regenerates the lock correctly, removing orphans)

To update flake.lock after editing flake.nix:
```bash
cd ~/Dots/nixosdots && nix flake lock
```

## Heavy inputs — avoid pulling repos for one file

If a flake input is a large repo (`flake = false`) and only one or two files are
used, prefer vendoring those files into the repo (e.g. `assets/`). This avoids
cloning hundreds of MB on every `nix flake update`. Example already done in this
repo: `nixy-wallpapers` (452MB) was replaced by a single `assets/cat-leaves.png`.

## Deprecation warnings are not errors

After a flake update, `dry-build` may show warnings like:
```
evaluation warning: The default value of `programs.neovim.withRuby` has changed...
```
These don't break the build (EXIT=0). You can silence them by explicitly setting
the option to the desired value (keeping legacy behavior), but it's optional.
Distinguish clearly for the user: "this is a warning, build still succeeds."

Some warnings come from nixpkgs itself (e.g. "nested list in propagatedBuildInputs")
— those are upstream packaging issues, not fixable from user config. Note them and
move on.

## Security: never expose tokens

If the user's rebuild command contains `--option access-tokens github.com=ghp_...`,
that token is now compromised the moment it appears in any log or conversation.
Strongly warn the user to revoke it at https://github.com/settings/tokens. Public
repo fetches in nix don't need tokens — the inputs are already cached after the
first build.

## Quick reference: the iteration loop

```
1. dry-build → see error
2. read error → identify root cause
3. minimal fix (edit one file)
4. dry-build → confirm EXIT=0, errors=0
   ↺ if error → back to 2
5. tell user "eval passes, you can switch" → STOP
```
