# AGENTS.md

## Purpose

This repository contains the NixOS and Home Manager configuration for the `matrix` host.

Primary entry points:

- `flake.nix`: top-level flake definition
- `hosts/matrix/default.nix`: exposes `flake.nixosConfigurations.matrix`
- `hosts/matrix/configuration.nix`: main system configuration for the host
- `home/synopia/default.nix`: Home Manager configuration for user `synopia`

## Repository Layout

- `hosts/matrix/`: host-specific NixOS configuration, hardware config, and user wiring
- `modules/nixos/`: shared NixOS modules imported by the host
- `modules/home-manager/`: shared Home Manager modules for shell, desktop, apps, services, Hyprland, Quickshell, and related tooling
- `home/synopia/`: user-specific Home Manager entry point and local assets

## Working Rules

- Keep changes scoped to the relevant layer:
  - system-wide NixOS behavior belongs under `modules/nixos/` or `hosts/matrix/`
  - user-level desktop and app behavior belongs under `modules/home-manager/` or `home/synopia/`
- Prefer extending existing modules over adding new top-level structure.
- Preserve existing import patterns and keep Nix expressions formatted with `nixfmt`.
- Do not modify `hosts/matrix/hardware-configuration.nix` unless the task is explicitly hardware-related.
- Treat secrets and local credentials carefully. The OpenVPN module references files copied from `$HOME/OpenVPN`; do not inline credentials into the repo.

## Validation

Run the narrowest command that matches the change:

- `nix fmt`
- `nix flake check`
- `nixos-rebuild build --flake .#matrix`
- `home-manager build --flake .#synopia` if Home Manager outputs are exposed later; otherwise validate through the host build

For changes under Hyprland, Quickshell, or Home Manager modules, prefer at least a host build to catch evaluation errors.

## Notes

- The flake currently imports only `./hosts/matrix`.
- Formatting is provided by `pkgs.nixfmt` in `flake.nix`.
- `home/synopia/default.nix` sets development paths for the Quickshell service to the in-repo Quickshell module directory.
