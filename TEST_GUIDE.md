# Test Guide

This document explains how to run unit tests, code coverage, and complexity analysis for the Mecanum Wheel project.

## Quick Start

The project includes a `test.sh` script to simplify running tasks via Docker.

```bash
# Run all unit tests
./test.sh

# Run code coverage
./test.sh gcov

# Run specific test (e.g., test_app.c)
./test.sh ceedling test:test_app

# Run complexity analysis (Lizard)
./test.sh lizard

# Run MISRA C:2012 Static Analysis (Cppcheck)
./test.sh misra

# Clean build artifacts
./test.sh clean
```

## Prerequisites

- **Docker**: Required for Ceedling unit tests and gcov.
- **Python 3 & Lizard**: Required for complexity analysis (install via `pip install lizard`).
- **Cppcheck**: Required for MISRA analysis (install via `brew install cppcheck`).

## Detailed Instructions

### 1. Unit Tests (Ceedling)
Tests are executed inside a Docker container (`throwtheswitch/madsciencelab-arm-none-eabi-plugins`).

- Run all tests: `./test.sh`
- Run a specific test task: `./test.sh ceedling [task]`
  - Example: `./test.sh ceedling test:test_app`

### 2. Code Coverage (gcov)
Generates HTML coverage reports.

- Run coverage: `./test.sh gcov`
- View report: Open `ceedling/build/artifacts/gcov/gcovr/coverage.html` in your browser.

### 3. Complexity Analysis (Lizard)
Runs cyclomatic complexity analysis on the `user` directory. Requires `lizard` installed on the host.

- Run analysis: `./test.sh lizard`

### 4. MISRA C:2012 Static Analysis (Cppcheck)
Runs MISRA compliance checks using Cppcheck with the MISRA addon. Requires `cppcheck` installed on the host.

- Run analysis: `./test.sh misra`
- Configuration: `misra.json` and `.misra_suppressions` (if exists).

## Directory Structure
- `ceedling/test/`: Test source files.
- `ceedling/project.yml`: Ceedling configuration.
- `ceedling/build/`: Build artifacts (ignored by git).
- `test.sh`: Main entry point script.
