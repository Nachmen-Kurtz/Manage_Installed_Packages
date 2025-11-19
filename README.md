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
    - [DNF](#dnf)
    - [Flatpak](#flatpak)
    - [RPM](#rpm)
    - [Cargo](#cargo)
  - [Use Cases](#use-cases)
  - [Troubleshooting](#troubleshooting)
    - [Permission Denied](#permission-denied)
    - [Package Manager Not Found](#package-manager-not-found)
    - [Database Files Not Found](#database-files-not-found)
  - [Examples](#examples)
    - [Running the Script](#running-the-script)
    - [Viewing Collected Data](#viewing-collected-data)
  - [Limitations](#limitations)
  - [Contributing](#contributing)
  - [License](#license)
  - [Version History](#version-history)
  - [Author](#author)
<!--toc:end-->

A comprehensive Bash script for collecting and archiving package management history and database information from multiple package managers on Linux systems.

## Overview

This script collects historical data and current state information from DNF, Flatpak, RPM, and Cargo package managers, organizing the output into timestamped directories for easy reference and backup.

## Features

- **Multi-Package Manager Support**: DNF, Flatpak, RPM, and Cargo
- **Timestamped Archives**: Each run creates a uniquely dated directory
- **Comprehensive History**: Collects transaction history, installed packages, and database files
- **Error Resilient**: Continues execution even if some package managers are not installed
- **Organized Output**: Separate subdirectories for each package manager

## Requirements

### System Requirements

- Linux distribution (Fedora, RHEL, or similar recommended)
- Bash shell (version 4.0 or higher)
- Root/sudo access (required for DNF operations and database copying)

### Package Managers

The script will collect data from any of the following that are installed:

- **DNF** (Dandified YUM) - Fedora/RHEL package manager
- **Flatpak** - Universal Linux application distribution
- **RPM** (RPM Package Manager) - Low-level package manager
- **Cargo** - Rust package manager

*Note: The script will skip any package manager that is not installed on your system.*

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

Run the script with sudo privileges:

```bash
sudo ./collect_package_history.sh
```

### Output Location

The script creates a timestamped directory in your current working directory:

```
Manage_Packages_YYYY-MM-DD_HH-MM-SS/
├── DNF/
│   ├── dnf_history_list.txt
│   ├── dnf_repolist.txt
│   ├── dnf_history_info_*.txt
│   ├── dnf_list_installed.txt
│   └── [libdnf5 database files]
├── Flatpak/
│   ├── flatpak_history.txt
│   ├── flatpak_list_apps.txt
│   └── flatpak_list_all.txt
├── RPM/
│   └── [RPM database files]
└── Cargo/
    └── cargo_install_list.txt
```

## What Gets Collected

### DNF

- Transaction history list
- Repository list
- Detailed information for each transaction
- List of all installed packages
- libdnf5 database files from `/usr/lib/sysimage/libdnf5/`

### Flatpak

- Application installation/update history
- List of installed applications
- List of all Flatpak packages (including runtimes)

### RPM

- Complete RPM database from `/usr/lib/sysimage/rpm/`

### Cargo

- List of all Rust packages installed via `cargo install`

## Use Cases

- **System Documentation**: Create snapshots of your package state
- **Troubleshooting**: Review installation history when debugging issues
- **Migration Planning**: Document current system state before upgrades
- **Backup Reference**: Keep records of package installations
- **Audit Trail**: Track changes to system packages over time

## Troubleshooting

### Permission Denied

If you see permission errors, ensure you're running with sudo:

```bash
sudo ./collect_package_history.sh
```

### Package Manager Not Found

If a package manager is missing, the script will display a warning and skip that section. This is normal behavior.

### Database Files Not Found

If database directories don't exist at the expected locations, the script will skip copying those files and display a warning.

## Examples

### Running the Script

```bash
$ sudo ./collect_package_history.sh
Script started at: 2024-11-19_14-30-45
Created directory structure in: Manage_Packages_2024-11-19_14-30-45

============================================
Collecting DNF History...
============================================
...
```

### Viewing Collected Data

```bash
# View DNF transaction history
cat Manage_Packages_*/DNF/dnf_history_list.txt

# View installed Flatpak apps
cat Manage_Packages_*/Flatpak/flatpak_list_apps.txt

# Check total size of collected data
du -sh Manage_Packages_*
```

## Limitations

- Requires root access for full functionality
- Database file copies can be large (especially RPM database)
- Does not collect data from other package managers (apt, zypper, pacman, etc.)
- Historical data depends on system retention policies

## Contributing

To extend this script for additional package managers or features, follow the established pattern:

1. Define output directory
2. Check if package manager exists
3. Run collection commands with error handling
4. Save output to appropriate subdirectory

## License

This script is provided as-is for system administration purposes.

## Version History

- **v1.0** - Initial release with DNF, Flatpak, RPM, and Cargo support

## Author

Created for comprehensive package management documentation and system state archival.
