# Package Management History Collection Script

<!--toc:start-->
- [Package Management History Collection Script](#package-management-history-collection-script)
  - [Overview](#overview)
  - [Features](#features)
  - [Requirements](#requirements)
    - [System Requirements](#system-requirements)
    - [Package Managers](#package-managers)
    - [Optional Tools](#optional-tools)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Basic Usage](#basic-usage)
    - [Output Location](#output-location)
  - [What Gets Collected](#what-gets-collected)
    - [DNF (Fedora/RHEL)](#dnf-fedorarhel)
    - [APT (Debian/Ubuntu)](#apt-debianubuntu)
    - [Pacman (Arch Linux)](#pacman-arch-linux)
    - [Flatpak](#flatpak)
    - [Cargo](#cargo)
    - [Homebrew (macOS)](#homebrew-macos)
  - [Use Cases](#use-cases)
  - [Script Output](#script-output)
    - [System Detection](#system-detection)
    - [Progress Indicators](#progress-indicators)
  - [Troubleshooting](#troubleshooting)
    - [Permission Denied](#permission-denied)
    - [Package Manager Not Found](#package-manager-not-found)
    - [Database Files Not Found](#database-files-not-found)
  - [Examples](#examples)
    - [Running the Script](#running-the-script)
    - [Viewing Collected Data](#viewing-collected-data)
  - [Supported Platforms](#supported-platforms)
  - [Limitations](#limitations)
  - [Contributing](#contributing)
  - [License](#license)
  - [Version History](#version-history)
  - [Author](#author)
<!--toc:end-->

A comprehensive Bash script for collecting and archiving package management history and database information from multiple package managers across Linux and macOS systems.

## Overview

This script automatically detects your operating system and available package managers, then collects historical data and current state information, organizing the output into timestamped directories for easy reference and backup.

## Features

- **🎨 Colorful Output**: Beautiful, color-coded progress indicators and status messages
- **🖥️ Multi-Platform Support**: Works on Linux (Fedora, Debian, Arch) and macOS
- **📦 Multi-Package Manager Support**: DNF, APT, Pacman, Flatpak, Cargo, and Homebrew
- **🔍 Automatic Detection**: Identifies your OS and installed package managers
- **⏰ Timestamped Archives**: Each run creates a uniquely dated directory
- **📊 Comprehensive History**: Collects transaction history, installed packages, and essential database files
- **💪 Error Resilient**: Continues execution even if some package managers are not installed
- **🗂️ Organized Output**: Separate subdirectories for each package manager
- **⚡ Optimized**: Only copies essential database files, saving disk space

## Requirements

### System Requirements

- Linux distribution (Fedora, Debian, Ubuntu, Arch, RHEL, or similar) **OR** macOS
- Bash shell (version 4.0 or higher)
- Root/sudo access (required for most operations and database copying on Linux)

### Package Managers

The script will automatically detect and collect data from any of the following that are installed:

- **DNF** (Dandified YUM) - Fedora/RHEL package manager
- **APT** (Advanced Package Tool) - Debian/Ubuntu package manager
- **Pacman** - Arch Linux package manager
- **Flatpak** - Universal Linux application distribution
- **Cargo** - Rust package manager
- **Homebrew** - macOS package manager

*Note: The script will automatically detect which package managers are available and skip those that aren't installed.*

### Optional Tools

- `tree` - For prettier directory structure output (recommended but not required)

## Installation

1. Download or create the script file:

```bash
nano collect_package_history.sh
```

2. Paste the script content and save

3. Make the script executable:

```bash
chmod +x collect_package_history.sh
```

## Usage

### Basic Usage

**Linux:**

```bash
sudo ./collect_package_history.sh
```

**macOS (Homebrew doesn't require sudo):**

```bash
./collect_package_history.sh
```

### Output Location

The script creates a timestamped directory in your current working directory:

```
Manage_Packages_YYYY-MM-DD_HH-MM-SS/
├── DNF/              (if DNF is detected)
│   ├── dnf_history_list.txt
│   ├── dnf_repolist.txt
│   ├── dnf_history_info_*.txt
│   ├── dnf_list_installed.txt
│   └── [essential database files]
├── APT/              (if APT is detected)
│   ├── apt_list_installed.txt
│   ├── history.log
│   ├── dpkg.log
│   ├── apt_cache_policy.txt
│   ├── sources.list
│   └── sources.list.d/
├── Pacman/           (if Pacman is detected)
│   ├── pacman_installed.txt
│   ├── pacman_explicit.txt
│   ├── pacman_foreign.txt
│   ├── pacman.log
│   └── mirrorlist
├── Flatpak/          (if Flatpak is detected)
│   ├── flatpak_history.txt
│   ├── flatpak_list_apps.txt
│   ├── flatpak_list_all.txt
│   └── flatpak_remotes.txt
├── RPM/              (if RPM/DNF is detected)
│   └── [essential database files]
├── Cargo/            (if Cargo is detected)
│   └── cargo_install_list.txt
└── Homebrew/         (if Homebrew is detected)
    ├── brew_list.txt
    ├── brew_list_cask.txt
    ├── brew_leaves.txt
    ├── brew_tap.txt
    └── brew_info.json
```

## What Gets Collected

### DNF (Fedora/RHEL)

- Transaction history list
- Repository list
- Detailed information for each transaction
- List of all installed packages
- **Essential database files only** (SQLite databases, .repo files)

### APT (Debian/Ubuntu)

- List of installed packages
- APT history logs (`/var/log/apt/history.log`)
- DPKG logs (`/var/log/dpkg.log`)
- APT cache policy
- Repository sources (`sources.list` and `sources.list.d/`)

### Pacman (Arch Linux)

- All installed packages (`pacman -Q`)
- Explicitly installed packages (`pacman -Qe`)
- Foreign/AUR packages (`pacman -Qm`)
- Installation log (`/var/log/pacman.log`)
- Mirror list configuration

### Flatpak

- Application installation/update history
- List of installed applications
- List of all Flatpak packages (including runtimes)
- Configured remotes

### Cargo

- List of all Rust packages installed via `cargo install`

### Homebrew (macOS)

- List of installed formulae
- List of installed casks
- Leaf packages (not dependencies)
- Configured taps
- Detailed package information (JSON format)

## Use Cases

- **System Documentation**: Create snapshots of your package state
- **Troubleshooting**: Review installation history when debugging issues
- **Migration Planning**: Document current system state before upgrades
- **Backup Reference**: Keep records of package installations
- **Audit Trail**: Track changes to system packages over time
- **Cross-Platform Management**: Maintain consistent documentation across different systems

## Script Output

### System Detection

At startup, the script displays:

- Operating system name and version
- Detected package managers
- Collection plan showing what will be gathered

Example output:

```
============================================
Package Management History Collection
============================================
Script started at: 2024-11-23_15-30-45

System Information
Operating System: Fedora Linux 39
OS Type: fedora

Available Package Managers
  ✓ DNF
  ✓ Flatpak
  ✓ Cargo

Collection Plan
The script will collect:
  • DNF: Transaction history, repositories, installed packages
  • Flatpak: History, installed applications
  • Cargo: Installed Rust packages
```

### Progress Indicators

- ✓ Green checkmarks for successful operations
- ⚠ Yellow warnings for non-critical issues
- ✗ Red errors for failures
- → Blue arrows for informational messages

## Troubleshooting

### Permission Denied

**Linux**: If you see permission errors, ensure you're running with sudo:

```bash
sudo ./collect_package_history.sh
```

**macOS**: Most Homebrew operations don't require sudo. Try running without it first.

### Package Manager Not Found

If a package manager is missing, the script will display a message and skip that section. This is normal behavior and not an error.

### Database Files Not Found

If database directories don't exist at the expected locations, the script will skip copying those files and display a warning.

## Examples

### Running the Script

```bash
$ sudo ./collect_package_history.sh

============================================
Package Management History Collection
============================================
Script started at: 2024-11-23_15-30-45

System Information
Operating System: Ubuntu 22.04 LTS
OS Type: ubuntu

Available Package Managers
  ✓ APT
  ✓ Flatpak

Collection Plan
The script will collect:
  • APT: Installation logs, installed packages, repositories
  • Flatpak: History, installed applications

✓ Created directory structure in: Manage_Packages_2024-11-23_15-30-45

============================================
Collecting APT History
============================================
→ Running: apt list --installed
✓ APT installed packages collected
...
```

### Viewing Collected Data

```bash
# View DNF transaction history
cat Manage_Packages_*/DNF/dnf_history_list.txt

# View installed APT packages
cat Manage_Packages_*/APT/apt_list_installed.txt

# View Pacman explicitly installed packages
cat Manage_Packages_*/Pacman/pacman_explicit.txt

# View Homebrew formulae
cat Manage_Packages_*/Homebrew/brew_list.txt

# Check total size of collected data
du -sh Manage_Packages_*
```

## Supported Platforms

| Platform | Package Managers | Status |
|----------|-----------------|--------|
| Fedora 33+ | DNF, RPM, Flatpak, Cargo | ✓ Tested |
| RHEL 8+ | DNF, RPM, Flatpak, Cargo | ✓ Tested |
| CentOS Stream | DNF, RPM, Flatpak, Cargo | ✓ Expected to work |
| Ubuntu 18.04+ | APT, Flatpak, Cargo | ✓ Expected to work |
| Debian 10+ | APT, Flatpak, Cargo | ✓ Expected to work |
| Arch Linux | Pacman, Flatpak, Cargo | ✓ Expected to work |
| Manjaro | Pacman, Flatpak, Cargo | ✓ Expected to work |
| macOS 10.15+ | Homebrew, Cargo | ✓ Expected to work |

## Limitations

- Linux systems require root/sudo access for full functionality
- **Optimized database copying**: Only essential files are copied to save space
- Does not collect data from other package managers (zypper, etc.)
- Historical data depends on system retention policies
- Homebrew on macOS doesn't require sudo but other package managers might

## Contributing

To extend this script for additional package managers or features, follow the established pattern:

1. Add package manager to detection function
2. Define output directory variable
3. Check if package manager command exists
4. Implement collection commands with colored output
5. Save output to appropriate subdirectory
6. Follow existing error handling pattern

## License

This script is provided as-is for system administration purposes.

## Version History

- **v2.0** - Multi-platform support (APT, Pacman, Homebrew), OS detection, colorful output, optimized database copying
- **v1.0** - Initial release with DNF, Flatpak, RPM, and Cargo support

## Author

Created for comprehensive package management documentation and system state archival across multiple platforms.
