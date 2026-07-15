# nixos-cfg

Personal NixOS flake for the `matrix` workstation. 

Its changing a lot right now.
Goals:
* stable and clean nix config structure
* consistent look and feel, generate theme/palette by matugen / noctalia
  * modifications where needed
* try / decide a dev tooling (dev*)
* somewhat reproducable build

## Changelog

### v3

* Niri + Noctalia
* flakes + hjem + rum

### v2

* Hyprland + custom Quickshell bar
* flakes + home-manager

### v1

* Hyprland + custom Quickshell bar
* few nix files, no flakes, no home-manager

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
|   |-- matrix/                
|       |-- config.nix         # active host profile
|-- lib/
|   |-- default.nix            # shared helpers
|-- modules/
|   |-- core/                  # systemwide configs
|   |-- services/              # systemd services
|   `-- desktop/               # niri and noctalia
```

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
