#!/bin/bash

# Package Management History Collection Script
# Collects history and information from DNF, Flatpak, RPM, and Cargo

set -e # Exit on error

# ============================================
# 1. PREPARATION - Store current date
# ============================================
echo ""
CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
echo ""
echo "Script started at: $CURRENT_DATE"

# ============================================
# 2. DEFINE READABLE OUTPUT NAMES
# ============================================
BASE_DIR="Manage_Packages_${CURRENT_DATE}"
FLATPAK_OUTPUT="${BASE_DIR}/Flatpak"
DNF_OUTPUT="${BASE_DIR}/DNF"
RPM_OUTPUT="${BASE_DIR}/RPM"
CARGO_OUTPUT="${BASE_DIR}/Cargo"

# Create base directory first
mkdir -p "$BASE_DIR"

# Create directory structure
mkdir -p "$FLATPAK_OUTPUT" "$DNF_OUTPUT" "$RPM_OUTPUT" "$CARGO_OUTPUT"
echo "Created directory structure in: $BASE_DIR"

# ============================================
# 3. RUN BASIC HISTORY RETRIEVAL COMMANDS
# ============================================

echo ""
echo "============================================"
echo "Collecting DNF History..."
echo "============================================"

# DNF history list
if command -v dnf &>/dev/null; then
  echo "Running: dnf history list"
  dnf history list >"${DNF_OUTPUT}/dnf_history_list.txt" 2>&1 || echo "Warning: dnf history list failed"

  # DNF repolist
  echo "Running: dnf repolist"
  dnf repolist >"${DNF_OUTPUT}/dnf_repolist.txt" 2>&1 || echo "Warning: dnf repolist failed"

  # Detailed history for each transaction ID
  echo "Running: dnf history info for each transaction"
  for id in $(dnf history list | awk '{print $1}' | grep '^[0-9]\+$'); do
    dnf history info "$id" >"${DNF_OUTPUT}/dnf_history_info_${id}.txt" 2>&1 || echo "Warning: Failed to get info for ID $id"
  done

  # Additional useful DNF commands
  echo "Running: dnf list --installed"
  dnf list --installed >"${DNF_OUTPUT}/dnf_list_installed.txt" 2>&1 || echo "Warning: dnf list installed failed"
else
  echo "DNF not found on this system, skipping DNF commands"
fi

echo ""
echo "============================================"
echo "Collecting Flatpak History..."
echo "============================================"

# Flatpak history
if command -v flatpak &>/dev/null; then
  echo "Running: flatpak history"
  flatpak history >"${FLATPAK_OUTPUT}/flatpak_history.txt" 2>&1 || echo "Warning: flatpak history failed"

  # Flatpak list apps
  echo "Running: flatpak list --app"
  flatpak list --app >"${FLATPAK_OUTPUT}/flatpak_list_apps.txt" 2>&1 || echo "Warning: flatpak list --app failed"

  # Additional: List all (including runtimes)
  echo "Running: flatpak list"
  flatpak list >"${FLATPAK_OUTPUT}/flatpak_list_all.txt" 2>&1 || echo "Warning: flatpak list failed"
else
  echo "Flatpak not found on this system, skipping Flatpak commands"
fi

echo ""
echo "============================================"
echo "Collecting Cargo Information..."
echo "============================================"

# Cargo installed packages
if command -v cargo &>/dev/null; then
  echo "Running: cargo install --list"
  cargo install --list >"${CARGO_OUTPUT}/cargo_install_list.txt" 2>&1 || echo "Warning: cargo install --list failed"
else
  echo "Cargo not found on this system, skipping Cargo commands"
fi

# ============================================
# 4. COPYING FILES
# ============================================

echo ""
echo "============================================"
echo "Copying Package Database Files..."
echo "============================================"

# Copy RPM database
if [ -d /usr/lib/sysimage/rpm ]; then
  echo "Copying RPM database from /usr/lib/sysimage/rpm/"
  cp -r /usr/lib/sysimage/rpm/* "${RPM_OUTPUT}/" 2>&1 || echo "Warning: Failed to copy some RPM files"
else
  echo "RPM database directory not found at /usr/lib/sysimage/rpm/, skipping"
fi

# Copy DNF/libdnf5 database
if [ -d /usr/lib/sysimage/libdnf5 ]; then
  echo "Copying DNF database from /usr/lib/sysimage/libdnf5/"
  cp -r /usr/lib/sysimage/libdnf5/* "${DNF_OUTPUT}/" 2>&1 || echo "Warning: Failed to copy some DNF files"
else
  echo "DNF database directory not found at /usr/lib/sysimage/libdnf5/, skipping"
fi

# ============================================
# COMPLETION SUMMARY
# ============================================

echo ""
echo "============================================"
echo "Package Management Data Collection Complete"
echo "============================================"
echo "Date: $CURRENT_DATE"
echo "Output directory: $BASE_DIR"
echo ""
echo "Directory structure:"
tree -L 2 "$BASE_DIR" 2>/dev/null || find "$BASE_DIR" -type d
echo ""
echo "Summary of collected files:"
find "$BASE_DIR" -type f -exec ls -lh {} \; | awk '{print $9, "(" $5 ")"}'
echo ""
echo "Total size:"
du -sh "$BASE_DIR"

exit 0
