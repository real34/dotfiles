# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

NixOS dotfiles for Pierre MARTIN (Lundi Matin — Front-Commerce, LMB, NEIA), using home-manager.

## Architecture

- `nixos/configuration.nix` — System-level NixOS config (bootloader, networking, services, system packages). Imports `hardware-configuration.nix` et `framework.nix`.
- `home.nix` — Entry point home-manager. Importe `packages.nix` et les modules de `programs/`. Mappe aussi les fichiers statiques depuis `files/`.
- `packages.nix` — Tous les packages utilisateur (avec allowlist unfree).
- `programs/` — Modules home-manager par programme : `git.nix`, `zsh.nix`, `i3.nix`, `neia.nix`.
- `files/` — Fichiers de config statiques copiés dans `$HOME` par home-manager (`.npmrc`, `.aider.conf.yml`, `traefik.toml`, etc.).
- `shell.nix` — Dev shell pour travailler sur les dotfiles eux-mêmes.

Home-manager est intégré au module NixOS (pas standalone). Appliquer avec `sudo nixos-rebuild switch`.

## Commands

```bash
make fmt       # Formater .nix (nixfmt) et .sh (shfmt)
make lint      # Linter les .sh avec shellcheck
make check     # Vérifier le formatage sans modifier
make clean     # Supprimer .direnv et result
```

Formatter Nix : `nixfmt-classic` (pas nixfmt-rfc-style).

## Appliquer les changements

Après modification des fichiers nix, appliquer avec :

```bash
sudo nixos-rebuild switch
```

Cette commande applique à la fois la config système (`nixos/`) et home-manager (`home.nix`, `packages.nix`, `programs/`). Un redémarrage n'est pas nécessaire sauf changement kernel/bootloader.

Si un package unfree est ajouté dans `packages.nix`, il faut aussi l'ajouter dans `nixpkgs.config.allowUnfreePredicate` (même fichier).

Si un nouveau module programme est créé dans `programs/`, il faut l'importer dans `home.nix`.

Après modification de fichiers `.sh`, lancer `make fmt && make lint` avant d'appliquer.

## Key details

- Keyboard layout : bépo (`fr` variant `bepo`)
- Window manager : i3 (Mod4)
- Shell : zsh + oh-my-zsh + starship + mcfly
- Terminal : sakura
- Git : difftastic (diffs), meld (merges), `push.autoSetupRemote = true`
- Node : fnm + bun
- Aliases utiles : `c` = claude, `p` = claude perso, `g` = git, `m` = make, `dc` = docker compose, `k`/`kp` = kubectl build/prod
