#!/bin/bash
# Usage:  ./build.sh            build (configures first if build/ doesn't exist yet)
#         ./build.sh --clean    delete build/ and configure from scratch
# Optional: GAME_DIR=/path/to/game/folder ./build.sh   copies the DLL there after each build.
set -euo pipefail
cd "$(dirname "$0")"

if [ "${1:-}" = "--clean" ]; then
  rm -rf build
fi

if [ ! -f build/CMakeCache.txt ]; then
  args=(
    -S . -B build
    -DCMAKE_TOOLCHAIN_FILE="$PWD/msvc-wine-toolchain.cmake"
    -DCMAKE_BUILD_TYPE=Release
  )
  if [ -n "${GAME_DIR:-}" ]; then
    args+=(-DGAME_DIR="$GAME_DIR")
  fi
  cmake "${args[@]}"
fi

cmake --build build -j"$(nproc)"
