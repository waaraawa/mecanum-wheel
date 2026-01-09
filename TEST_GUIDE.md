# Test Guide

This document explains how to run unit tests and generate code coverage reports for the Mecanum Wheel project using Ceedling and Docker.

## Prerequisites

- **Docker**: Ensure Docker is installed and running on your machine.
- **Docker Image**: The project uses the `throwtheswitch/madsciencelab-arm-none-eabi-plugins:latest` image.

## Directory Structure

The unit tests are located in the `ceedling` directory:
- `ceedling/test/`: Contains test files (`test_*.c`).
- `ceedling/project.yml`: Ceedling configuration file.
- `ceedling/build/`: (Generated) Build artifacts and reports.

## Running Unit Tests

Run the following command from the project root directory. This command mounts the current directory into the Docker container and executes `ceedling test:all`.

```bash
docker run --rm -v "$(pwd):/home/dev/project" \
  throwtheswitch/madsciencelab-arm-none-eabi-plugins:latest \
  bash -c "cd /home/dev/project/ceedling && ceedling test:all"
```

### Expected Output
You should see a summary of passed, failed, and ignored tests.
```
-----------------------
✅ OVERALL TEST SUMMARY
-----------------------
TESTED:  X
PASSED:  Y
FAILED:  Z
IGNORED: W
```

## Running Code Coverage (gcov)

Run the following command from the project root directory to generate code coverage reports.

```bash
docker run --rm -v "$(pwd):/home/dev/project" \
  throwtheswitch/madsciencelab-arm-none-eabi-plugins:latest \
  bash -c "cd /home/dev/project/ceedling && ceedling gcov:all"
```

### Viewing Coverage Reports
After running the gcov command, the HTML coverage report will be generated at:
`ceedling/build/artifacts/gcov/gcovr/coverage.html`

You can open this file in your web browser to view the detailed line-by-line coverage.
