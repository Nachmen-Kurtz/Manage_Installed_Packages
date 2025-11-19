# Package Management History Collection Script - Specification

<!--toc:start-->
- [Package Management History Collection Script - Specification](#package-management-history-collection-script-specification)
  - [Document Information](#document-information)
  - [1. Overview](#1-overview)
    - [1.1 Purpose](#11-purpose)
    - [1.2 Scope](#12-scope)
  - [2. Functional Requirements](#2-functional-requirements)
    - [2.1 Date Management (FR-001)](#21-date-management-fr-001)
    - [2.2 Output Structure (FR-002)](#22-output-structure-fr-002)
    - [2.3 Data Collection Commands (FR-003)](#23-data-collection-commands-fr-003)
      - [2.3.1 DNF Commands](#231-dnf-commands)
      - [2.3.2 Flatpak Commands](#232-flatpak-commands)
      - [2.3.3 Cargo Commands](#233-cargo-commands)
      - [2.3.4 Command Execution Pattern](#234-command-execution-pattern)
    - [2.4 File System Operations (FR-004)](#24-file-system-operations-fr-004)
      - [2.4.1 Database Copy Operations](#241-database-copy-operations)
  - [3. Non-Functional Requirements](#3-non-functional-requirements)
    - [3.1 Performance (NFR-001)](#31-performance-nfr-001)
    - [3.2 Reliability (NFR-002)](#32-reliability-nfr-002)
    - [3.3 Security (NFR-003)](#33-security-nfr-003)
    - [3.4 Usability (NFR-004)](#34-usability-nfr-004)
  - [4. Technical Specifications](#4-technical-specifications)
    - [4.1 Shell Requirements](#41-shell-requirements)
    - [4.2 System Dependencies](#42-system-dependencies)
    - [4.3 File Paths](#43-file-paths)
    - [4.4 Output File Naming Convention](#44-output-file-naming-convention)
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

- **Version**: 1.0
- **Date**: 2024-11-19
- **Status**: Implemented
- **Purpose**: Technical specification for package management data collection script

## 1. Overview

### 1.1 Purpose

This script collects comprehensive package management history and database information from multiple package managers on Linux systems, organizing the data into timestamped archives for documentation, backup, and troubleshooting purposes.

### 1.2 Scope

The script handles four package management systems:

- DNF (Dandified YUM)
- Flatpak
- RPM (RPM Package Manager)
- Cargo (Rust package manager)

## 2. Functional Requirements

### 2.1 Date Management (FR-001)

**Requirement**: The script must capture and store the current date/time at execution start.

**Implementation**:

- Format: `YYYY-MM-DD_HH-MM-SS`
- Storage: Shell variable `CURRENT_DATE`
- Usage: Directory naming and audit trail

**Rationale**: Enables multiple script executions without data collision and provides temporal context for collected data.

### 2.2 Output Structure (FR-002)

**Requirement**: Create organized directory structure with readable names for each package manager.

**Directory Hierarchy**:

```
Manage_Packages_${CURRENT_DATE}/
├── DNF/
├── Flatpak/
├── RPM/
└── Cargo/
```

**Variable Definitions**:

- `BASE_DIR`: Root directory with timestamp
- `DNF_OUTPUT`: DNF data subdirectory
- `FLATPAK_OUTPUT`: Flatpak data subdirectory
- `RPM_OUTPUT`: RPM data subdirectory
- `CARGO_OUTPUT`: Cargo data subdirectory

### 2.3 Data Collection Commands (FR-003)

#### 2.3.1 DNF Commands

**Required Commands**:

1. `dnf history list` → `dnf_history_list.txt`
   - Lists all transaction IDs and summaries

2. `dnf repolist` → `dnf_repolist.txt`
   - Lists configured repositories

3. `dnf history info "$id"` → `dnf_history_info_${id}.txt`
   - Detailed information for each transaction ID
   - Iterates over all numeric IDs from history list
   - Extraction: `awk '{print $1}' | grep '^[0-9]\+$'`

**Additional Commands**:
4. `dnf list installed` → `dnf_list_installed.txt`

- Complete snapshot of installed packages

#### 2.3.2 Flatpak Commands

**Required Commands**:

1. `flatpak history` → `flatpak_history.txt`
   - Installation/update history

2. `flatpak list --app` → `flatpak_list_apps.txt`
   - List of installed applications only

**Additional Commands**:
3. `flatpak list` → `flatpak_list_all.txt`

- Complete list including runtimes

#### 2.3.3 Cargo Commands

**Required Commands**:

1. `cargo install --list` → `cargo_install_list.txt`
   - List of Rust packages installed globally

#### 2.3.4 Command Execution Pattern

All commands must:

- Redirect both stdout and stderr to output files (`> file.txt 2>&1`)
- Include error handling with fallback messages
- Check for command existence before execution

### 2.4 File System Operations (FR-004)

#### 2.4.1 Database Copy Operations

**Source → Destination Mappings**:

1. **RPM Database**:
   - Source: `/usr/lib/sysimage/rpm/*`
   - Destination: `${RPM_OUTPUT}/`
   - Method: Recursive copy (`cp -r`)

2. **DNF/libdnf5 Database**:
   - Source: `/usr/lib/sysimage/libdnf5/*`
   - Destination: `${DNF_OUTPUT}/`
   - Method: Recursive copy (`cp -r`)

**Error Handling**:

- Check directory existence before copying
- Display warning messages if source not found
- Continue execution on copy failures

## 3. Non-Functional Requirements

### 3.1 Performance (NFR-001)

- Script execution time: < 5 minutes for typical systems
- No optimization required for history iteration
- Sequential execution acceptable

### 3.2 Reliability (NFR-002)

- Must not fail if package managers are missing
- Must continue on individual command failures
- Exit code 0 on successful completion
- Use `set -e` for critical errors only at script level

### 3.3 Security (NFR-003)

- Requires root/sudo privileges for:
  - DNF history access
  - System database file copying
- No sensitive data filtering required
- Output directories should inherit umask permissions

### 3.4 Usability (NFR-004)

- Clear progress messages during execution
- Section headers for each package manager
- Summary report at completion
- Directory structure visualization

## 4. Technical Specifications

### 4.1 Shell Requirements

- **Interpreter**: `/bin/bash`
- **Minimum Version**: 4.0
- **Required Features**:
  - Command substitution `$()`
  - Process substitution
  - Associative arrays (for future enhancements)

### 4.2 System Dependencies

**Required**:

- `date` - Timestamp generation
- `mkdir` - Directory creation
- `cp` - File copying
- `awk` - Text processing
- `grep` - Pattern matching

**Optional**:

- `tree` - Directory visualization
- `find` - Fallback for directory listing
- `du` - Size calculation

### 4.3 File Paths

**Hardcoded System Paths**:

- `/usr/lib/sysimage/rpm/` - RPM database location (Fedora 33+)
- `/usr/lib/sysimage/libdnf5/` - DNF5 database location

**Note**: These paths are specific to modern Fedora/RHEL systems. Older systems may use `/var/lib/rpm/`.

### 4.4 Output File Naming Convention

**Pattern**: `${packagemanager}_${command}_${identifier}.txt`

**Examples**:

- `dnf_history_list.txt`
- `dnf_history_info_42.txt`
- `flatpak_list_apps.txt`
- `cargo_install_list.txt`

## 5. Data Flow

### 5.1 Execution Sequence

```
1. Capture timestamp
2. Define output paths
3. Create directory structure
4. FOR EACH package manager:
   4.1. Check if command exists
   4.2. Execute collection commands
   4.3. Save output to files
   4.4. Handle errors gracefully
5. Copy database files
6. Generate summary report
7. Exit with status 0
```

### 5.2 Error Handling Strategy

**Levels**:

1. **Critical**: Script-level failures (directory creation)
   - Action: Exit immediately (`set -e`)

2. **Warning**: Command failures, missing tools
   - Action: Log warning, continue execution

3. **Informational**: Missing package managers
   - Action: Display message, skip section

## 6. Output Specifications

### 6.1 Standard Output

**Progress Messages**:

- Timestamp at start
- Directory creation confirmation
- Section headers for each package manager
- Individual command execution notices
- Summary report at completion

**Summary Report Contents**:

- Completion timestamp
- Output directory path
- Directory structure tree/list
- File inventory with sizes
- Total archive size

### 6.2 File Output

**Text Format**:

- Encoding: UTF-8
- Line endings: Unix (LF)
- No size limits on individual files

**Binary Files**:

- Database files copied as-is
- No compression applied

## 7. Constraints and Limitations

### 7.1 Known Limitations

1. **Package Manager Coverage**: Only supports DNF, Flatpak, RPM, Cargo
2. **Database Paths**: Hardcoded for Fedora 33+ layout
3. **History Depth**: Limited by system retention policies
4. **No Compression**: Raw file copies may consume significant disk space
5. **No Incremental Backup**: Each run is a full snapshot

### 7.2 System Requirements

**Minimum Disk Space**:

- DNF history: ~1-10 MB (typical)
- RPM database: ~100-500 MB (typical)
- Flatpak data: ~1-5 MB (typical)
- Total: ~500 MB to 1 GB recommended free space

**Memory**: Minimal (<100 MB)

**CPU**: Any modern processor

## 8. Future Enhancements

### 8.1 Potential Features (Not Implemented)

- Compression of output directory (tar.gz)
- Configuration file for custom paths
- Filtering options for date ranges
- Support for additional package managers (apt, zypper, pacman)
- Incremental backup mode
- Automatic cleanup of old archives
- JSON output format option
- Remote backup integration

### 8.2 Extensibility Points

The script structure allows easy addition of new package managers by:

1. Adding output directory variable
2. Adding command existence check
3. Implementing collection commands
4. Following existing error handling pattern

## 9. Testing Considerations

### 9.1 Test Scenarios

1. **All package managers present**: Verify complete data collection
2. **Missing package managers**: Verify graceful skipping
3. **Insufficient permissions**: Verify error messages
4. **Missing database directories**: Verify warnings and continuation
5. **Multiple executions**: Verify unique directory creation
6. **Disk space constraints**: Verify behavior on low disk space

### 9.2 Validation Criteria

- Output directory created with correct timestamp
- All expected subdirectories present
- Command outputs saved to correct files
- Database files copied successfully
- Summary report generated
- Exit code 0 on success

## 10. Maintenance

### 10.1 Update Triggers

Script should be reviewed/updated when:

- System database paths change
- New package managers need support
- DNF/RPM major version updates
- Fedora/RHEL major release changes

### 10.2 Compatibility Matrix

**Tested On**:

- Fedora 33+
- RHEL 8+
- CentOS Stream 8+

**Expected To Work**:

- Any DNF-based distribution
- Systems with `/usr/lib/sysimage/` layout

## 11. References

- DNF Documentation: <https://dnf.readthedocs.io/>
- Flatpak Documentation: <https://docs.flatpak.org/>
- RPM Database: <https://rpm.org/>
- Cargo Documentation: <https://doc.rust-lang.org/cargo/>

## 12. Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-11-19 | Initial specification |

## 13. Approval

This specification serves as the design document for the package management history collection script implementation.
