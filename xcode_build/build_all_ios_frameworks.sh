#!/usr/bin/env bash
# Build all iOS frameworks for MediaPipe

set -ex

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This build script only works on macOS."
  exit 1
fi

# Check for Xcode installation
if ! command -v xcodebuild &> /dev/null; then
  echo "xcodebuild is required but not installed. Please install Xcode."
  exit 1
fi

MPP_ROOT_DIR=$(git rev-parse --show-toplevel)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR=${DEST_DIR:-"${SCRIPT_DIR}/frameworks"}

echo "Building all iOS frameworks..."
echo "Destination: ${DEST_DIR}"

# Create destination directory
mkdir -p "${DEST_DIR}"

# List of all frameworks to build
FRAMEWORKS=(
  "MediaPipeTasksCommon"
  "MediaPipeTasksVision" 
  "MediaPipeTasksText"
  "MediaPipeTasksAudio"
  "MediaPipeTasksGenAI"
)

# Build each framework
for FRAMEWORK in "${FRAMEWORKS[@]}"; do
  echo ""
  echo "========================================="
  echo "Building ${FRAMEWORK}..."
  echo "========================================="
  
  export FRAMEWORK_NAME="${FRAMEWORK}"
  export DEST_DIR="${DEST_DIR}"
  
  # Run the build script
  "${SCRIPT_DIR}/build_ios_framework_xcode_complete.sh"
  
  if [[ $? -eq 0 ]]; then
    echo "✅ ${FRAMEWORK} built successfully"
  else
    echo "❌ ${FRAMEWORK} build failed"
  fi
done

echo ""
echo "========================================="
echo "All framework builds completed!"
echo "========================================="
echo "Built frameworks:"
for FRAMEWORK in "${FRAMEWORKS[@]}"; do
  echo "  - ${FRAMEWORK}"
done
echo "Location: ${DEST_DIR}"