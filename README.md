# nixos-cfg

Personal NixOS flake for the `matrix` workstation. The configuration is built
around a small feature system under the `matrix.*` option namespace, with NixOS,
Home Manager, Hyprland, Quickshell, Niri, Noctalia, desktop apps, development tooling, and
system services kept in focused modules.

## Hosts

The active flake output is:

```sh
nixosConfigurations.matrix
```

## Layout

```text
.
|-- flake.nix                  # inputs, host builder, dev shell
|-- flake.lock                 # pinned input revisions
|-- hosts/
|   |-- matrix/                # active host profile
|   `-- matrix-vm/             # VM host profile, currently disabled in flake
|-- lib/
|   |-- default.nix            # shared helpers
|   `-- mkFeature.nix          # matrix.* feature module helper
|-- modules/
|   |-- core/                  # base user, boot, and styling modules
|   `-- features/              # optional feature modules
|-- users/
|   `-- synopia.nix            # user identity and feature enablement
```

Feature modules are auto-imported by `modules/features/default.nix`. Any
`*.nix` file under `modules/features/` is imported unless it is named
`default.nix`.

## Feature Model

Most optional behavior is declared with `lib.matrix.mkFeature`. A feature gets a
`matrix.<name>.enable` option by default and can contribute both system and Home
Manager configuration:

```nix
args@{ lib, pkgs, ... }:
with lib;
with lib.matrix;
mkFeature args {
  name = "apps.example";

  nixos = {
    environment.systemPackages = [ pkgs.example ];
  };

  home = {
    programs.example.enable = true;
  };
}
```

Enable or configure features in `users/synopia.nix`:

```nix
matrix.apps.example = enabled;
```

Use `enabled` and `disabled` from `lib.matrix` for simple toggles, and define
extra options inside the feature module when a feature needs settings.

## Common Commands

Run these from the repository root.

Enter the development shell:

```sh
nix develop
```

Evaluate the flake:

```sh
nix flake check
```

Build the active host without switching:

```sh
nix build .#nixosConfigurations.matrix.config.system.build.toplevel
```

Apply the configuration on the `matrix` host:

```sh
sudo nixos-rebuild switch --flake .#matrix
```

Update pinned inputs:

```sh
nix flake update
```

Review `flake.lock` after updating inputs, and keep dependency updates separate
from unrelated behavior changes when practical.

## Formatting And Checks

The dev shell provides tools for the languages used in this repo, including
`alejandra`, `nil`, `shellcheck`, `shfmt`, and Qt/QML tooling.

Suggested validation sequence:

```sh
alejandra .
nix flake check
nix build .#nixosConfigurations.matrix.config.system.build.toplevel
```

For shell scripts, run `shellcheck` and `shfmt` on the affected files. For
desktop changes, switch locally and verify the affected Hyprland, Quickshell,
Home Manager, or app behavior.

## Desktop Configuration

Hyprland is configured from:

```text
modules/features/desktop/wm/hyprland.nix
modules/features/desktop/wm/hyprland/
```

Quickshell is configured from:

```text
modules/features/desktop/shell/quickshell.nix
modules/features/desktop/shell/quickshell/
```

The active desktop feature toggles live under `matrix.desktop` in
`users/synopia.nix`.

## Secrets And Local State

Do not commit credentials, private VPN files, generated build outputs, or
machine-local state. OpenVPN profiles are ignored with:

```gitignore
*.ovpn
```

If a module needs a secret, prefer referencing an external file or secret
manager instead of embedding the value in Nix.
