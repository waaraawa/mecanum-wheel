# Build CLI Guide

This document explains how to use `build_cli.sh` to build the Mecanum Wheel project from the command line. This build process is independent of the STM32CubeIDE build (which uses the `build/` directory) and puts artifacts in `build_cli/`.

## Prerequisites

- **CMake**: Ensure CMake (version 3.22 or higher) is installed.
- **Arm GNU Toolchain**: Ensure `arm-none-eabi-gcc` is in your system PATH or configured in `cmake/gcc-arm-none-eabi.cmake` and `CMakeLists.txt`.

## Usage

Run the script from the project root directory:

```bash
./build_cli.sh [type] [command]
```

### Arguments

- **Type** (Optional, Default: `debug`):
  - `d` or `debug`: Build with debug symbols.
  - `r` or `release`: Build optimized release version.

- **Command** (Optional, Default: `build`):
  - `config` or `cfg`: Configure CMake (generate build files).
  - `build` or `b`: Build the project (compile and link).
  - `clean` or `c`: Remove the `build_cli` directory for the selected type.
  - `clean-build` or `cb`: Perform a clean followed by a config and build.

## Examples

1. **Clean Build (Debug)** - *Recommended for first run or when in doubt*
   ```bash
   ./build_cli.sh d cb
   ```
   This cleans the old build, configures CMake, and builds the Debug target.

2. **Standard Build (Debug)**
   ```bash
   ./build_cli.sh
   ```
   Incremental build for Debug target.

3. **Release Build**
   ```bash
   ./build_cli.sh r cb
   ```
   Clean build for Release target.

4. **Clean Only**
   ```bash
   ./build_cli.sh c
   ```

## Output Locations

- **Debug Artifacts**: `build_cli/debug/mecanum_wheel_mod.elf`
- **Release Artifacts**: `build_cli/release/mecanum_wheel_mod.elf`

## Note on IDE vs CLI

- **CLI Build**: Uses `build_cli/` directory. Useful for CI/CD or terminal-based workflow.
- **IDE Build**: Uses `build/` directory. Useful for GUI debugging in VSCode/STM32CubeIDE.
