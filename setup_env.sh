#!/bin/bash

# ==============================================================================
# SCRIPT CONFIGURATION
# ==============================================================================
set -euo pipefail

# Path Configuration
BASE_DEV_DIR="/mnt/data/dev"
BASE_WORK_DIR="/mnt/data/dev_workspaces"

# Subdirectories to create in DEV
SUBDIRS=("packages" "apps" "web" "science" "infra" "playground" "_setup")

# KDE Directory Icons (Functional settings, not visual output)
ICON_DEV="folder-code-symbolic"
ICON_WORK="docker"

# ==============================================================================
# PRE-FLIGHT CHECKS
# ==============================================================================

if [ "$(id -u)" -ne 0 ]; then
    echo "[ERROR] This script must be run as root. Use: sudo $0" >&2
    exit 1
fi

# Detect the actual user behind sudo
REAL_USER=${SUDO_USER:-$USER}
REAL_GROUP=$(id -gn "$REAL_USER")

# ==============================================================================
# FUNCTIONS
# ==============================================================================

log_info() {
    echo "[INFO] $1"
}

create_directories() {
    log_info "Creating directory structure..."

    # Create base directories
    mkdir -p "$BASE_DEV_DIR"
    mkdir -p "$BASE_WORK_DIR"

    # Create subdirectories
    for subdir in "${SUBDIRS[@]}"; do
        mkdir -p "$BASE_DEV_DIR/$subdir"
    done
}

configure_kde_icons() {
    log_info "Configuring directory meta-data (.directory)..."

    # Define the content for the .directory file
    local dev_config="[Desktop Entry]\nIcon=${ICON_DEV}\nType=Directory"
    local work_config="[Desktop Entry]\nIcon=${ICON_WORK}\nType=Directory"

    echo -e "$dev_config" > "$BASE_DEV_DIR/.directory"
    echo -e "$work_config" > "$BASE_WORK_DIR/.directory"
}

create_documentation() {
    log_info "Generating README.md documentation..."

    # README for DEV
    cat > "$BASE_DEV_DIR/README.md" <<EOF
# Development Library

This directory contains source code only (Git Repositories).
It is NOT synchronized via Nextcloud, but backed up via Borg.

## Structure
* packages/   - Reusable libraries (PyPI, NPM)
* apps/       - Standalone applications
* web/        - Frontend projects
* science/    - Data Science & Analysis
* infra/      - Infrastructure & Docker
* playground/ - Temporary tests
* _setup/     - Environment setup scripts

## Rules
* No large binary data (CSVs, DBs).
* Use Symlinks or Environment Variables for real data in /mnt/data/kyellsen/Nextcloud.
EOF

    # README for WORKSPACES
    cat > "$BASE_WORK_DIR/README.md" <<EOF
# Workspaces & Labs

This directory contains ephemeral data, container volumes, and caches.
It is NEITHER synchronized NOR backed up.

## Naming Convention
Create a folder here that matches the repository name in dev/.

Example:
* Code:      /mnt/data/dev/packages/arbolab_core
* Workspace: /mnt/data/dev_workspaces/arbolab_core

## Usage
* Mount Docker Volumes here.
* Temporary script outputs.
* Content is volatile.
EOF
}

set_permissions() {
    log_info "Applying ownership and permissions for user: $REAL_USER..."

    # Set ownership recursively
    chown -R "$REAL_USER:$REAL_GROUP" "$BASE_DEV_DIR"
    chown -R "$REAL_USER:$REAL_GROUP" "$BASE_WORK_DIR"

    # Set Directory Permissions (755: User RWX, Group/Other RX)
    find "$BASE_DEV_DIR" -type d -exec chmod 755 {} +
    find "$BASE_WORK_DIR" -type d -exec chmod 755 {} +

    # Set File Permissions (Smart Mode: Preserve executable flags)
    # u+rw = User gets read/write
    # go+r = Group/Others get read
    # We do NOT force 644, so existing executable scripts stay executable.
    find "$BASE_DEV_DIR" -type f -exec chmod u+rw,go+r {} +
    find "$BASE_WORK_DIR" -type f -exec chmod u+rw,go+r {} +

    # Ensure this script remains executable if it exists in target
    if [ -f "$BASE_DEV_DIR/_setup/setup_env.sh" ]; then
        chmod +x "$BASE_DEV_DIR/_setup/setup_env.sh"
    fi
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

create_directories
configure_kde_icons
create_documentation
set_permissions

log_info "Setup completed successfully."
