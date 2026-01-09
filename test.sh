#!/bin/bash

# Test script wrapper for Ceedling (Docker) and Lizard

DOCKER_IMG="throwtheswitch/madsciencelab-arm-none-eabi-plugins:latest"
PROJECT_ROOT=$(pwd)
CEEDLING_DIR="/home/dev/project/ceedling"

print_usage() {
    echo "Usage: ./test.sh [command] [args...]"
    echo ""
    echo "Commands:"
    echo "  (empty)         Run all unit tests (ceedling test:all)"
    echo "  gcov            Run code coverage (ceedling gcov:all)"
    echo "  lizard          Run complexity analysis (lizard)"
    echo "  clean           Clean build artifacts (ceedling clobber)"
    echo "  ceedling [args] Execute a raw ceedling command via Docker"
    echo "                  Example: ./test.sh ceedling test:test_app"
    echo "  help            Show this help message"
}

run_ceedling() {
    docker run --rm -v "$PROJECT_ROOT:/home/dev/project" \
        $DOCKER_IMG \
        bash -c "cd $CEEDLING_DIR && ceedling $*"
}

case "$1" in
    "")
        run_ceedling test:all
        ;;
    "gcov")
        run_ceedling gcov:all utils:gcov
        ;;
    "clean")
        run_ceedling clobber
        ;;
    "lizard")
        if ! command -v lizard &> /dev/null; then
            echo "Error: 'lizard' not found. Please install it with 'pip install lizard'."
            exit 1
        fi
        lizard user
        ;;
    "ceedling")
        shift
        if [ -z "$1" ]; then
            echo "Error: ceedling command required. Usage: ./test.sh ceedling [task]"
            exit 1
        fi
        run_ceedling "$@"
        ;;
    "help"|"-h"|"--help")
        print_usage
        ;;
    *)
        echo "Unknown command: $1"
        print_usage
        exit 1
        ;;
esac
