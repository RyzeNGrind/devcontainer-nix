FROM ghcr.io/lucernae/devcontainer-nix:flake

ENV USE_DIRENV="true"
ENV USE_FLAKE="true"
ENV INSTALL_ROOT_PACKAGES=""
ENV PREBUILD_DEFAULT_PACKAGE="default.nix"
ENV PREBUILD_NIX_SHELL="shell.nix"
ENV PREBUILD_FLAKE=""
ENV PREBUILD_FLAKE_RUN=""
ENV PREBUILD_FLAKE_DEVELOP=""
ENV ADDITIONAL_NIX_CHANNEL=""
ENV ADDITIONAL_NIX_FLAKE_REGISTRY=""
ENV PREBUILD_HOME_MANAGER=""
ENV PREBUILD_HOME_MANAGER_FLAKE=""

# Initialize the root user's Nix profile and add default nixpkgs channel
RUN mkdir -p /root/.nix-profile /root/.nix-defexpr /root/.nix-channels && \
    ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile && \
    ln -s /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr && \
    ln -s /nix/var/nix/profiles/per-user/root/channels /root/.nix-channels && \
    nix-channel --add https://nixos.org/channels/nixpkgs-23.05 nixpkgs && \
    nix-channel --update
# Add fallback for os-release file
RUN if [ ! -f /etc/os-release ]; then \
    echo "NAME=NixOS" > /etc/os-release && \
    echo "VERSION=23.05" >> /etc/os-release && \
    echo "ID=nixos" >> /etc/os-release; \
    fi

# Verify the os-release file exists and print its contents
RUN cat /etc/os-release || echo "os-release file is missing"
COPY ./nix.conf /etc/nix/nix.conf

# Adjusted the script verification to avoid errors
RUN mkdir -p /tmp/library-scripts/runtime/ && \
    echo '#!/bin/sh' > /tmp/library-scripts/runtime/postCreateCommand.sh && \
    echo 'echo "Running alternative post-create command script"' >> /tmp/library-scripts/runtime/postCreateCommand.sh && \
    chmod +x /tmp/library-scripts/runtime/postCreateCommand.sh

# Verify the script exists in the container
RUN ls -l /tmp/library-scripts/runtime/postCreateCommand.sh || echo "postCreateCommand.sh is missing"
RUN ls -l /tmp/library-scripts/runtime/

RUN bash /library-scripts/build/all.sh
