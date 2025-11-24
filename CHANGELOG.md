# Changelog

All notable changes to the Package Management History Collection Script will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2024-11-24

### Removed
- **DNF transaction details loop**: Removed the collection of individual transaction details (`dnf history info "$id"`) that created hundreds of separate files
  - Rationale: Reduces file clutter while maintaining essential history in the summary list
  - Impact: DNF section now creates 3-4 files instead of potentially hundreds

### Changed
- DNF collection now focuses on summary data rather than verbose per-transaction details

### Documentation
- Updated README.md to reflect removed DNF transaction details
- Updated SPECIFICATION.md to v2.1 with removal notes
- Created CHANGELOG.md to track all version changes

## [2.0.0] - 2024-11-23

### Added
- **Multi-platform support**: Added support for Debian/Ubuntu (APT), Arch Linux (Pacman), and macOS (Homebrew)
- **Automatic OS detection**: Script now detects operating system and displays name/version at startup
- **Automatic package manager detection**: Only collects data from installed package managers
- **Colorful ANSI output**: Added color-coded messages with status indicators (✓, ⚠, ✗, →)
- **Pre-execution information display**: Shows OS info, detected package managers, and collection plan before starting
- **Helper functions**: Created `print_success()`, `print_warning()`, `print_error()`, `print_info()`, `print_header()`, `print_section()`

#### New Package Managers
- **APT (Debian/Ubuntu)**:
  - `apt list --installed` - Installed packages
  - `/var/log/apt/history.log` - Installation history
  - `/var/log/dpkg.log` - DPKG operations log
  - `apt-cache policy` - Repository priorities
  - `/etc/apt/sources.list` - Repository sources
  - `/etc/apt/sources.list.d/` - Additional sources

- **Pacman (Arch Linux)**:
  - `pacman -Q` - All installed packages
  - `pacman -Qe` - Explicitly installed packages
  - `pacman -Qm` - Foreign/AUR packages
  - `/var/log/pacman.log` - Installation log
  - `/etc/pacman.d/mirrorlist` - Mirror configuration

- **Homebrew (macOS)**:
  - `brew list` - Installed formulae
  - `brew list --cask` - Installed casks
  - `brew leaves` - Top-level packages
  - `brew tap` - Configured taps
  - `brew info --json=v2 --installed` - Detailed package metadata

#### Additional Features
- **Flatpak remotes**: Added `flatpak remotes` collection

### Changed
- **BREAKING**: Optimized database copying for DNF/RPM to only copy essential files
  - Before: Copied entire directories (~500MB for RPM, ~100MB for DNF)
  - After: Only copies `*.sqlite`, `*.db`, `*.repo` files (~10-50MB total)
  - Reduces typical collection size from ~500MB to ~50MB
- Directory structure now dynamically adapts to detected package managers
- Only creates subdirectories for package managers that are actually installed

### Improved
- Script execution feedback with clear visual progress
- Summary report now includes file count and individual file sizes
- Better error handling with colored warnings
- Enhanced user experience with informative startup messages

### Documentation
- Completely rewrote README.md for v2.0 with multi-platform coverage
- Updated SPECIFICATION.md to v2.0 with detailed technical specifications
- Added compatibility matrix for supported distributions
- Added color scheme documentation
- Added new package manager command references

## [1.0.0] - 2024-11-19

### Added
- Initial release of Package Management History Collection Script
- Support for **DNF** (Dandified YUM):
  - `dnf history list` - Transaction history
  - `dnf repolist` - Repository list
  - `dnf history info "$id"` - Detailed info for each transaction
  - `dnf list --installed` - All installed packages
  - Database files from `/usr/lib/sysimage/libdnf5/`

- Support for **RPM** (RPM Package Manager):
  - Database files from `/usr/lib/sysimage/rpm/`

- Support for **Flatpak**:
  - `flatpak history` - Installation/update history
  - `flatpak list --app` - Installed applications
  - `flatpak list` - All packages including runtimes

- Support for **Cargo** (Rust):
  - `cargo install --list` - Installed Rust packages

### Features
- Timestamped directory creation (`Manage_Packages_YYYY-MM-DD_HH-MM-SS`)
- Organized subdirectories for each package manager
- Error resilience - continues if package managers are missing
- Summary report with directory structure and file sizes

### Documentation
- Created README.md with installation and usage instructions
- Created SPECIFICATION.md with technical design documentation

---

## Version Comparison Summary

| Feature | v1.0 | v2.0 | v2.1 |
|---------|------|------|------|
| DNF Support | ✓ | ✓ | ✓ |
| APT Support | ✗ | ✓ | ✓ |
| Pacman Support | ✗ | ✓ | ✓ |
| Homebrew Support | ✗ | ✓ | ✓ |
| Flatpak Support | ✓ | ✓ | ✓ |
| Cargo Support | ✓ | ✓ | ✓ |
| RPM Support | ✓ | ✓ | ✓ |
| OS Detection | ✗ | ✓ | ✓ |
| Colorful Output | ✗ | ✓ | ✓ |
| Optimized DB Copy | ✗ | ✓ | ✓ |
| DNF Transaction Details | ✓ | ✓ | ✗ |
| Typical Output Size | ~500MB | ~50MB | ~50MB |
| Platform Support | Linux | Linux + macOS | Linux + macOS |

---

## Migration Guide

### Upgrading from v1.0 to v2.1

**Breaking Changes:**
1. Database directories now contain only essential files (not full copies)
2. DNF no longer creates individual transaction detail files
3. Output directory structure varies based on detected package managers

**Benefits:**
- 90% reduction in disk space usage
- Faster execution (no hundreds of dnf history info calls)
- Multi-platform support
- Better user experience with colored output

**Action Required:**
- None - script is backward compatible
- Old v1.0 archives remain valid
- New v2.1 archives are simply more efficient

### Upgrading from v2.0 to v2.1

**Breaking Changes:**
- DNF transaction detail files (`dnf_history_info_*.txt`) are no longer created

**Benefits:**
- Cleaner output directory
- Faster DNF collection
- Still maintains transaction history summary in `dnf_history_list.txt`

**Action Required:**
- If you relied on individual transaction details, use `dnf history info <id>` manually
- Summary information is still available in `dnf_history_list.txt`

---

## Future Roadmap

### Planned for v2.2
- Compression option (tar.gz output)
- Configuration file support
- Filtering by date range

### Planned for v3.0
- Snap package manager support
- Nix package manager support
- Remote backup integration
- Incremental backup mode

### Under Consideration
- GUI wrapper
- Progress bars for long operations
- Email notifications
- JSON output format
- Parallel execution

---

## Contributing

When contributing, please:
1. Update this CHANGELOG.md with your changes
2. Follow [Keep a Changelog](https://keepachangelog.com/) format
3. Update version numbers in README.md and SPECIFICATION.md
4. Use semantic versioning for version numbers

## Links

- [README.md](README.md) - User documentation
- [SPECIFICATION.md](SPECIFICATION.md) - Technical specification
- [Repository Issues](#) - Report bugs or request features
