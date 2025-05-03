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
RUN mkdir -p /root/.nix-profile /root/.nix-defexpr || true && \
    mkdir -p /root/.nix-channels || true && \
    # Remove existing targets if they're files rather than symlinks
    rm -f /root/.nix-profile 2>/dev/null || true && \
    rm -f /root/.nix-defexpr 2>/dev/null || true && \
    rm -f /root/.nix-channels 2>/dev/null || true && \
    # Create the symlinks if they don't exist
    [ -L /root/.nix-profile ] || ln -sf /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile 2>/dev/null || true && \
    [ -L /root/.nix-defexpr ] || ln -sf /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr 2>/dev/null || true && \
    [ -L /root/.nix-channels ] || ln -sf /nix/var/nix/profiles/per-user/root/channels /root/.nix-channels 2>/dev/null || true && \
    # Skip these commands if any of the above failed
    nix-channel --list || (nix-channel --add https://nixos.org/channels/nixpkgs-23.05 nixpkgs && \
    nix-channel --update)

# Handle os-release safely - instead of directly writing to /etc, create a local version
RUN if [ ! -f /etc/os-release ]; then \
    echo "Using local os-release file since system one is missing" && \
    mkdir -p /tmp/os-info && \
    echo "NAME=NixOS" > /tmp/os-info/os-release && \
    echo "VERSION=23.05" >> /tmp/os-info/os-release && \
    echo "ID=nixos" >> /tmp/os-info/os-release; \
    fi

# Verify the os-release file exists and print its contents
RUN cat /etc/os-release 2>/dev/null || cat /tmp/os-info/os-release 2>/dev/null || echo "os-release file is missing"

COPY ./nix.conf /etc/nix/nix.conf
# Copy the runtime scripts into the container
COPY .devcontainer/library-scripts /library-scripts

# Debug step to verify the presence of .devcontainer/library-scripts
RUN ls -l .devcontainer/library-scripts || echo "Directory not found"

RUN chmod +x /library-scripts/runtime/postCreateCommand.sh

# Verify the script exists in the container
RUN ls -l /library-scripts/runtime/postCreateCommand.sh || echo "postCreateCommand.sh is missing"
RUN ls -l /library-scripts/runtime/

RUN bash /library-scripts/build/all.sh
