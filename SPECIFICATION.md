# Package Management History Collection Script - Specification

<!--toc:start-->
- [Package Management History Collection Script - Specification](#package-management-history-collection-script-specification)
  - [Document Information](#document-information)
  - [1. Overview](#1-overview)
    - [1.1 Purpose](#11-purpose)
    - [1.2 Scope](#12-scope)
  - [2. Functional Requirements](#2-functional-requirements)
    - [2.1 Date Management (FR-001)](#21-date-management-fr-001)
    - [2.2 OS and Package Manager Detection (FR-002)](#22-os-and-package-manager-detection-fr-002)
    - [2.3 Output Structure (FR-003)](#23-output-structure-fr-003)
    - [2.4 Data Collection Commands (FR-004)](#24-data-collection-commands-fr-004)
      - [2.4.1 DNF Commands](#241-dnf-commands)
      - [2.4.2 APT Commands](#242-apt-commands)
      - [2.4.3 Pacman Commands](#243-pacman-commands)
      - [2.4.4 Flatpak Commands](#244-flatpak-commands)
      - [2.4.5 Cargo Commands](#245-cargo-commands)
      - [2.4.6 Homebrew Commands](#246-homebrew-commands)
      - [2.4.7 Command Execution Pattern](#247-command-execution-pattern)
    - [2.5 File System Operations (FR-005)](#25-file-system-operations-fr-005)
      - [2.5.1 Database Copy Operations](#251-database-copy-operations)
    - [2.6 User Interface and Feedback (FR-006)](#26-user-interface-and-feedback-fr-006)
  - [3. Non-Functional Requirements](#3-non-functional-requirements)
    - [3.1 Performance (NFR-001)](#31-performance-nfr-001)
    - [3.2 Reliability (NFR-002)](#32-reliability-nfr-002)
    - [3.3 Security (NFR-003)](#33-security-nfr-003)
    - [3.4 Usability (NFR-004)](#34-usability-nfr-004)
    - [3.5 Portability (NFR-005)](#35-portability-nfr-005)
  - [4. Technical Specifications](#4-technical-specifications)
    - [4.1 Shell Requirements](#41-shell-requirements)
    - [4.2 System Dependencies](#42-system-dependencies)
    - [4.3 File Paths](#43-file-paths)
    - [4.4 Output File Naming Convention](#44-output-file-naming-convention)
    - [4.5 Color Scheme](#45-color-scheme)
  - [5. Data Flow](#5-data-flow)
    - [5.1 Execution Sequence](#51-execution-sequence)
    - [5.2 Error Handling Strategy](#52-error-handling-strategy)
  - [6. Output Specifications](#6-output-specifications)
    - [6.1 Standard Output](#61-standard-output)
    - [6.2 File Output](#62-file-output)
  - [7. Constraints and Limitations](#7-constraints-and-limitations)
    - [7.1 Known Limitations](#71-known-limitations)
    - [7.2 System Requirements](#72-system-requirements)
  - [8. Future Enhancements](#8-future-enhancements)
    - [8.1 Potential Features (Not Implemented)](#81-potential-features-not-implemented)
    - [8.2 Extensibility Points](#82-extensibility-points)
  - [9. Testing Considerations](#9-testing-considerations)
    - [9.1 Test Scenarios](#91-test-scenarios)
    - [9.2 Validation Criteria](#92-validation-criteria)
  - [10. Maintenance](#10-maintenance)
    - [10.1 Update Triggers](#101-update-triggers)
    - [10.2 Compatibility Matrix](#102-compatibility-matrix)
  - [11. References](#11-references)
  - [12. Version History](#12-version-history)
  - [13. Approval](#13-approval)
<!--toc:end-->

## Document Information

- **Version**: 2.1
- **Date**: 2024-11-24
- **Status**: Implemented
- **Purpose**: Technical specification for cross-platform package management data collection script

## 1. Overview

### 1.1 Purpose

This script collects comprehensive package management history and database information from multiple package managers across Linux and macOS systems, organizing the data into timestamped archives for documentation, backup, and troubleshooting purposes.

### 1.2 Scope

The script handles seven package management systems across multiple platforms:

- **DNF** (Dandified YUM) - Fedora/RHEL
- **APT** (Advanced Package Tool) - Debian/Ubuntu
- **Pacman** - Arch Linux
- **Flatpak** - Universal Linux application distribution
- **RPM** (RPM Package Manager) - Low-level package manager
- **Cargo** - Rust package manager (cross-platform)
- **Homebrew** - macOS package manager

## 2. Functional Requirements

### 2.1 Date Management (FR-001)

**Requirement**: The script must capture and store the current date/time at execution start.

**Implementation**:

- Format: `YYYY-MM-DD_HH-MM-SS`
- Storage: Shell variable `CURRENT_DATE`
- Usage: Directory naming and audit trail

**Rationale**: Enables multiple script executions without data collision and provides temporal context for collected data.

### 2.2 OS and Package Manager Detection (FR-002)

**Requirement**: The script must automatically detect the operating system and available package managers before data collection.

**Implementation**:

- **OS Detection**:
  - Parse `/etc/os-release` on Linux systems
  - Use `sw_vers` on macOS
  - Extract: OS name, version, and ID
  
- **Package Manager Detection**:
  - Check for command existence using `command -v`
  - Build array of available package managers
  - Only create directories for detected managers

**Output Information**:

- Display OS name and version
- List detected package managers with visual indicators
- Show collection plan before execution

**Rationale**: Provides transparency, avoids unnecessary operations, and adapts to different system configurations.

### 2.3 Output Structure (FR-003)

**Requirement**: Create organized directory structure with readable names for each detected package manager.

**Directory Hierarchy**:

```
Manage_Packages_${CURRENT_DATE}/
├── DNF/        (if DNF detected)
├── APT/        (if APT detected)
├── Pacman/     (if Pacman detected)
├── Flatpak/    (if Flatpak detected)
├── RPM/        (if RPM detected)
├── Cargo/      (if Cargo detected)
└── Homebrew/   (if Homebrew detected)
```

**Variable Definitions**:

- `BASE_DIR`: Root directory with timestamp
- `DNF_OUTPUT`: DNF data subdirectory
- `APT_OUTPUT`: APT data subdirectory
- `PACMAN_OUTPUT`: Pacman data subdirectory
- `FLATPAK_OUTPUT`: Flatpak data subdirectory
- `RPM_OUTPUT`: RPM data subdirectory
- `CARGO_OUTPUT`: Cargo data subdirectory
- `HOMEBREW_OUTPUT`: Homebrew data subdirectory

### 2.4 Data Collection Commands (FR-004)

#### 2.4.1 DNF Commands

**Required Commands**:

1. `dnf history list` → `dnf_history_list.txt`
   - Lists all transaction IDs and summaries

2. `dnf repolist` → `dnf_repolist.txt`
   - Lists configured repositories

3. `dnf list --installed` → `dnf_list_installed.txt`
   - Complete snapshot of installed packages

**Note**: Individual transaction details (`dnf history info`) are NOT collected to avoid creating hundreds of files.

#### 2.4.2 APT Commands

**Required Commands**:

1. `apt list --installed` → `apt_list_installed.txt`
2. `apt-cache policy` → `apt_cache_policy.txt`
3. Copy `/var/log/apt/history.log` → `history.log`
4. Copy `/var/log/dpkg.log` → `dpkg.log`
5. Copy `/etc/apt/sources.list` → `sources.list`
6. Copy `/etc/apt/sources.list.d/` → `sources.list.d/`

#### 2.4.3 Pacman Commands

**Required Commands**:

1. `pacman -Q` → `pacman_installed.txt`
2. `pacman -Qe` → `pacman_explicit.txt`
3. `pacman -Qm` → `pacman_foreign.txt`
4. Copy `/var/log/pacman.log` → `pacman.log`
5. Copy `/etc/pacman.d/mirrorlist` → `mirrorlist`

#### 2.4.4 Flatpak Commands

**Required Commands**:

1. `flatpak history` → `flatpak_history.txt`
2. `flatpak list --app` → `flatpak_list_apps.txt`
3. `flatpak list` → `flatpak_list_all.txt`
4. `flatpak remotes` → `flatpak_remotes.txt`

#### 2.4.5 Cargo Commands

**Required Commands**:

1. `cargo install --list` → `cargo_install_list.txt`

#### 2.4.6 Homebrew Commands

**Required Commands**:

1. `brew list` → `brew_list.txt`
2. `brew list --cask` → `brew_list_cask.txt`
3. `brew leaves` → `brew_leaves.txt`
4. `brew tap` → `brew_tap.txt`
5. `brew info --json=v2 --installed` → `brew_info.json`

#### 2.4.7 Command Execution Pattern

All commands must:

- Redirect both stdout and stderr to output files (`> file.txt 2>&1`)
- Include error handling with colored feedback messages
- Check for command existence before execution
- Use `&&` and `||` for success/failure feedback

### 2.5 File System Operations (FR-005)

#### 2.5.1 Database Copy Operations

**Optimized Copy Strategy**:

1. **RPM Database** (Essential files only):
   - Source: `/usr/lib/sysimage/rpm/`
   - Filter: `*.sqlite`, `rpmdb.sqlite`, `Packages`
   - Destination: `${RPM_OUTPUT}/`
   - Method: Selective copy using `find` with `-maxdepth 1`

2. **DNF/libdnf5 Database** (Essential files only):
   - Source: `/usr/lib/sysimage/libdnf5/`
   - Filter: `*.sqlite`, `*.db`, `*.repo`
   - Destination: `${DNF_OUTPUT}/`
   - Method: Selective copy using `find` with `-maxdepth 2`

3. **APT Logs**:
   - Copy `/var/log/apt/history.log`
   - Copy `/var/log/dpkg.log`
   - Copy sources configuration files

4. **Pacman Logs**:
   - Copy `/var/log/pacman.log`
   - Copy `/etc/pacman.d/mirrorlist`

**Rationale**: Copying only essential files significantly reduces disk space usage while maintaining all necessary information. Full database directories can be hundreds of megabytes.

**Error Handling**:

- Check directory/file existence before copying
- Display colored warning messages if source not found
- Continue execution on copy failures

### 2.6 User Interface and Feedback (FR-006)

**Requirement**: Provide clear, colorful, and informative feedback throughout execution.

**Implementation**:

- **Color-coded Messages**: Use ANSI color codes
- **Status Indicators**: Unicode symbols (✓, ⚠, ✗, →)
- **Progress Headers**: Cyan/bold section dividers
- **Informational Output**: Display OS info and collection plan upfront

**Helper Functions**:

- `print_header()` - Cyan bold headers
- `print_success()` - Green checkmarks
- `print_warning()` - Yellow warnings
- `print_error()` - Red error messages
- `print_info()` - Blue informational messages
- `print_section()` - Magenta section titles

## 3. Non-Functional Requirements

### 3.1 Performance (NFR-001)

- Script execution time: < 5 minutes for typical systems
- Optimized database copying reduces I/O operations
- Sequential execution acceptable

### 3.2 Reliability (NFR-002)

- Must not fail if package managers are missing
- Must continue on individual command failures
- Exit code 0 on successful completion
- Use `set -e` for critical errors only at script level

### 3.3 Security (NFR-003)

- **Linux**: Requires root/sudo privileges for:
  - Package manager history access
  - System log file copying
  - Database file access
- **macOS**: Homebrew typically doesn't require sudo
- No sensitive data filtering required
- Output directories inherit umask permissions

### 3.4 Usability (NFR-004)

- Clear, colorful progress messages
- Visual status indicators for all operations
- Section headers for each package manager
- Summary report at completion
- Directory structure visualization
- Pre-execution information display

### 3.5 Portability (NFR-005)

- Support Linux distributions: Fedora, RHEL, Debian, Ubuntu, Arch
- Support macOS 10.15+
- Graceful degradation on unsupported systems
- Automatic adaptation to available package managers

## 4. Technical Specifications

### 4.1 Shell Requirements

- **Interpreter**: `/bin/bash`
- **Minimum Version**: 4.0
- **Required Features**:
  - Command substitution `$()`
  - Arrays and array manipulation
  - ANSI color code support
  - Conditional expressions

### 4.2 System Dependencies

**Required**:

- `date` - Timestamp generation
- `mkdir` - Directory creation
- `cp` - File copying
- `awk` - Text processing
- `grep` - Pattern matching
- `find` - File searching
- `command` - Command existence checking

**Optional**:

- `tree` - Directory visualization
- `du` - Size calculation
- `wc` - File counting

**Platform-Specific**:

- Linux: Access to `/etc/os-release`
- macOS: `sw_vers` command

### 4.3 File Paths

**Linux System Paths**:

- `/usr/lib/sysimage/rpm/` - RPM database (Fedora 33+)
- `/usr/lib/sysimage/libdnf5/` - DNF5 database
- `/var/lib/rpm/` - RPM database (older systems)
- `/var/log/apt/history.log` - APT history (Debian/Ubuntu)
- `/var/log/dpkg.log` - DPKG log (Debian/Ubuntu)
- `/var/log/pacman.log` - Pacman log (Arch)
- `/etc/apt/sources.list` - APT sources (Debian/Ubuntu)
- `/etc/pacman.d/mirrorlist` - Pacman mirrors (Arch)

**macOS Paths**:

- Homebrew uses standard user directories

### 4.4 Output File Naming Convention

**Pattern**: `${packagemanager}_${command}_${identifier}.txt`

**Examples**:

- `dnf_history_list.txt`
- `apt_list_installed.txt`
- `pacman_explicit.txt`
- `brew_list_cask.txt`
- `flatpak_remotes.txt`

### 4.5 Color Scheme

**ANSI Color Codes**:

```bash
RED='\033[0;31m'      # Errors
GREEN='\033[0;32m'    # Success
YELLOW='\033[1;33m'   # Warnings
BLUE='\033[0;34m'     # Info
MAGENTA='\033[0;35m'  # Section titles
CYAN='\033[0;36m'     # Headers
WHITE='\033[1;37m'    # Important text
BOLD='\033[1m'        # Emphasis
NC='\033[0m'          # Reset/No Color
```

**Status Symbols**:

- ✓ Success (Green)
- ⚠ Warning (Yellow)
- ✗ Error (Red)
- → Info (Blue)

## 5. Data Flow

### 5.1 Execution Sequence

```
1. Initialize color codes and helper functions
2. Capture timestamp
3. Display script header
4. Detect operating system
5. Detect available package managers
6. Display system information
7. Display available package managers
8. Display collection plan
9. Define output paths
10. Create base directory
11. Create subdirectories for detected managers
12. FOR EACH detected package manager:
    12.1. Display section header
    12.2. Execute collection commands
    12.3. Display colored status for each operation
    12.4. Copy relevant files/databases
    12.5. Handle errors gracefully
13. Generate summary report
14. Display directory structure
15. Display file count and sizes
16. Exit with status 0
```

### 5.2 Error Handling Strategy

**Levels**:

1. **Critical**: Script-level failures (directory creation)
   - Action: Exit immediately (`set -e`)

2. **Warning**: Command failures, missing files
   - Action: Display yellow warning, continue execution

3. **Informational**: Missing package managers
   - Action: Skip section silently (not listed in available managers)

**Feedback Pattern**:

```bash
command && print_success "message" || print_warning "message"
```

## 6. Output Specifications

### 6.1 Standard Output

**Startup Information**:

- Script title in cyan header
- Timestamp in white bold
- OS name and version
- List of detected package managers with green checkmarks
- Collection plan showing what will be gathered

**Progress Messages**:

- Section headers for each package manager (cyan bold)
- Individual command execution notices (blue arrows)
- Success confirmations (green checkmarks)
- Warning messages (yellow warnings)
- Error messages (red X marks)

**Summary Report Contents**:

- Completion header
- Timestamp
- Output directory path
- Directory structure (tree or find output)
- File count
- Individual file details
- Total archive size

### 6.2 File Output

**Text Format**:

- Encoding: UTF-8
- Line endings: Unix (LF)
- No size limits on individual files

**Binary Files**:

- Database files copied as-is
- No compression applied

**JSON Format** (Homebrew):

- Valid JSON v2 format from `brew info`

## 7. Constraints and Limitations

### 7.1 Known Limitations

1. **Package Manager Coverage**: Supports DNF, APT, Pacman, Flatpak, RPM, Cargo, Homebrew (not zypper, yum, etc.)
2. **Database Paths**: Hardcoded for modern system layouts
3. **History Depth**: Limited by system retention policies
4. **No Compression**: Raw file copies (no tar.gz)
5. **No Incremental Backup**: Each run is a full snapshot
6. **Optimized Copying**: Only essential database files copied (reduces completeness but saves space)

### 7.2 System Requirements

**Minimum Disk Space**:

- DNF essential files: ~5-20 MB (reduced from 100-500 MB)
- RPM essential files: ~10-50 MB (reduced from 100-500 MB)
- APT logs: ~1-10 MB
- Pacman data: ~1-10 MB
- Flatpak data: ~1-5 MB
- Homebrew data: ~1-10 MB
- Total: ~50-200 MB recommended free space (significantly reduced)

**Memory**: Minimal (<100 MB)

**CPU**: Any modern processor

**Terminal**: ANSI color code support (most modern terminals)

## 8. Future Enhancements

### 8.1 Potential Features (Not Implemented)

- Compression of output directory (tar.gz/zip)
- Configuration file for custom paths
- Filtering options for date ranges
- Support for additional package managers (zypper, yum, nix, snap)
- Incremental backup mode
- Automatic cleanup of old archives
- JSON output format option
- Remote backup integration
- Parallel execution for faster collection
- GUI wrapper
- Option to include/exclude database files
- Configurable verbosity levels

### 8.2 Extensibility Points

The script structure allows easy addition of new package managers:

1. Add detection to `detect_package_managers()`
2. Add output directory variable
3. Add to `AVAILABLE_PKG_MGRS` array check
4. Implement collection section with colored output
5. Follow existing error handling pattern

## 9. Testing Considerations

### 9.1 Test Scenarios

1. **All package managers present**: Verify complete data collection
2. **Partial package managers**: Verify selective collection
3. **No package managers**: Verify graceful exit
4. **Insufficient permissions**: Verify error messages
5. **Missing database directories**: Verify warnings and continuation
6. **Multiple executions**: Verify unique directory creation
7. **Disk space constraints**: Verify behavior on low disk space
8. **Different OS distributions**: Test on Fedora, Ubuntu, Arch, macOS
9. **Terminal without color support**: Verify graceful degradation
10. **Optimized copying**: Verify only essential files copied

### 9.2 Validation Criteria

- Output directory created with correct timestamp
- Only directories for detected managers created
- OS information displayed correctly
- All expected subdirectories present
- Command outputs saved to correct files
- Essential database files copied successfully
- Colored output displayed correctly
- Summary report generated with accurate counts
- Exit code 0 on success

## 10. Maintenance

### 10.1 Update Triggers

Script should be reviewed/updated when:

- System database paths change
- New package managers need support
- Package manager command syntax changes
- New Linux distributions emerge
- macOS major version changes
- User feedback on optimization needs

### 10.2 Compatibility Matrix

**Tested On**:

- Fedora 33+
- RHEL 8+
- CentOS Stream 8+
- Ubuntu 18.04+
- Debian 10+
- Arch Linux (current)
- macOS 10.15+

**Expected To Work**:

- Any DNF-based distribution
- Any APT-based distribution
- Any Pacman-based distribution (Manjaro, etc.)
- Systems with `/usr/lib/sysimage/` layout
- Systems with Homebrew installed

## 11. References

- DNF Documentation: <https://dnf.readthedocs.io/>
- APT Documentation: <https://wiki.debian.org/Apt>
- Pacman Documentation: <https://wiki.archlinux.org/title/Pacman>
- Flatpak Documentation: <https://docs.flatpak.org/>
- RPM Database: <https://rpm.org/>
- Cargo Documentation: <https://doc.rust-lang.org/cargo/>
- Homebrew Documentation: <https://docs.brew.sh/>
- ANSI Color Codes: <https://en.wikipedia.org/wiki/ANSI_escape_code>

## 12. Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.1 | 2024-11-24 | Removed verbose DNF transaction details collection to reduce file clutter |
| 2.0 | 2024-11-23 | Added APT, Pacman, Homebrew support; OS detection; colored output; optimized database copying |
| 1.0 | 2024-11-19 | Initial specification with DNF, Flatpak, RPM, Cargo |

## 13. Approval

This specification serves as the design document for the cross-platform package management history collection script implementation.
