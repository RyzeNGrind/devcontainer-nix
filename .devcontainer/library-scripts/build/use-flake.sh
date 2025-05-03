#!/usr/bin/env bash

if [[ "${USE_FLAKE}" == "true" ]]; then
    echo "Use Flake mode is activated"
    echo "Upgrading Nix to latest release"
    nix --version

    # Add and update nixpkgs channel
    if ! nix-channel --list | grep -q "nixpkgs"; then
        nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
        nix-channel --update
    fi

    nix-env -iA nixpkgs.nix nixpkgs.cacert
    nix --version

    echo "Will attempt to install packages using Nix Flake commands"
    flags=('nix-command' 'flakes')
    experimentalFeaturesEnabled="$(grep "experimental-features" /etc/nix/nix.conf || true)"
    if [[ -z "$experimentalFeaturesEnabled" ]]; then
        echo "experimental-features = " >> /etc/nix/nix.conf
    fi
    for flag in "${flags[@]}"; do
        flagExists="$(grep "^experimental-features\s*=.*$flag" /etc/nix/nix.conf || true)"
        if [[ -z "$flagExists" ]]; then
            sed -i "s/^experimental-features\s*=.*/& $flag/" /etc/nix/nix.conf
        fi
    done
fi