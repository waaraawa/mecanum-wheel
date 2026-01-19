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
    echo "  misra           Run MISRA C:2012 static analysis (cppcheck)"
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
    "misra")
        if ! command -v cppcheck &> /dev/null; then
            echo "Error: 'cppcheck' not found. Please install it (e.g., 'brew install cppcheck')."
            exit 1
        fi

        COMPILE_DB="build_cli/debug/compile_commands.json"
        # Fallback to check if build_cli.sh was run simply as ./build_cli.sh (Debug)
        if [ ! -f "$COMPILE_DB" ]; then
            echo "Error: '$COMPILE_DB' not found."
            echo "Please run './build_cli.sh config' (or ./build_cli.sh) to generate it."
            exit 1
        fi

        # Detect CPU cores for parallel processing
        if [[ "$OSTYPE" == "darwin"* ]]; then
            CORES=$(sysctl -n hw.ncpu)
        else
            if command -v nproc &> /dev/null; then
                CORES=$(nproc)
            else
                CORES=1
            fi
        fi
        
        # Filter compile_commands.json to include only user/ files
        # This speeds up analysis and avoids checking library code
        FILTERED_DB="user_compile_commands.json"
        echo "Filtering compile_commands.json to $FILTERED_DB..."
        python3 -c "import json; db=json.load(open('$COMPILE_DB')); print(json.dumps([e for e in db if '/user/' in e['file']]))" > "$FILTERED_DB"

        echo "Running MISRA C:2012 analysis on user code (Cores: $CORES)..."
        cppcheck --project="$FILTERED_DB" --addon=misra.json --std=c99 --platform=mips32 -D__GNUC__ -j $CORES \
            --suppress="*:*Drivers/*" --suppress="*:*Core/*" --suppress="*:*Middlewares/*" \
            --enable=style,warning,performance,portability --inline-suppr --suppress=missingIncludeSystem \
            --quiet --error-exitcode=1
        
        EXIT_CODE=$?
        rm -f "$FILTERED_DB"
        rm -f *.dump *.ctu-info
        
        if [ $EXIT_CODE -ne 0 ]; then
            echo "MISRA check failed."
            exit 1
        else
            echo "MISRA check passed."
        fi
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
