#!/bin/bash

# Build script for mecanum_wheel project
# Usage: ./build.sh [type] [command]
# Types: r/release, d/debug (default: debug)
# Commands: config/cfg, build/b, clean/c, clean-build/cb

PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR="build_cli/$(echo $TYPE | tr '[:upper:]' '[:lower:]')"
TOOLCHAIN="../cmake/gcc-arm-none-eabi.cmake"

# Get build type
get_build_type() {
    case $1 in
        r|release) echo "Release" ;;
        d|debug) echo "Debug" ;;
        *) echo "Debug" ;;
    esac
}

# Parse arguments
TYPE=""
CMD=""
for arg in "$@"; do
    case $arg in
        r|d|release|debug)
            TYPE=$(get_build_type $arg)
            ;;
        config|cfg)
            CMD="config"
            ;;
        build|b)
            CMD="build"
            ;;
        clean|c)
            CMD="clean"
            ;;
        clean-build|cb)
            CMD="clean-build"
            ;;
        *)
            echo "Unknown argument: $arg"
            echo "Usage: ./build.sh [r|d|release|debug] [config|cfg|build|b|clean|c|clean-build|cb]"
            exit 1
            ;;
    esac
done

# Default
if [ -z "$TYPE" ]; then TYPE="Debug"; fi
if [ -z "$CMD" ]; then CMD="build"; fi

# Set build dir based on type
BUILD_DIR="build_cli/$(echo $TYPE | tr '[:upper:]' '[:lower:]')"

echo "Build Type: $TYPE, Command: $CMD, Dir: $BUILD_DIR"

# Execute
case $CMD in
    config|cfg)
        mkdir -p $BUILD_DIR
        cd $BUILD_DIR
        cmake -S $PROJECT_ROOT -B . -DCMAKE_TOOLCHAIN_FILE=$PROJECT_ROOT/cmake/gcc-arm-none-eabi.cmake -DCMAKE_BUILD_TYPE=$TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        ;;
    build|b)
        if [ ! -d "$BUILD_DIR" ]; then
            echo "Build directory not found. Run './build.sh config' first."
            exit 1
        fi
        cd $BUILD_DIR
        cmake --build .
        ;;
    clean|c)
        rm -rf $BUILD_DIR
        echo "Cleaned $BUILD_DIR"
        ;;
    clean-build|cb)
        rm -rf $BUILD_DIR
        mkdir -p $BUILD_DIR
        cd $BUILD_DIR
        cmake -S $PROJECT_ROOT -B . -DCMAKE_TOOLCHAIN_FILE=$PROJECT_ROOT/cmake/gcc-arm-none-eabi.cmake -DCMAKE_BUILD_TYPE=$TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        cmake --build .
        ;;
esac
