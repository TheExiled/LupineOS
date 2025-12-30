#!/bin/bash

# Configuration Variables
# Configuration Variables
GITHUB_USER="theexiled" # Must be lowercase for GHCR
IMAGE_NAME="lupineos"
TAG="latest"
FEDORA_VERSION="41"
ISO_NAME="lupineos-${FEDORA_VERSION}"

echo "----------------------------------------------------------------"
echo "Starting ISO Generation for: ghcr.io/${GITHUB_USER}/${IMAGE_NAME}:${TAG}"
echo "Target Fedora Version: $FEDORA_VERSION"
echo "Output ISO: $(pwd)/$ISO_NAME.iso"
echo "----------------------------------------------------------------"

# Check if Podman is installed
if ! command -v podman &> /dev/null; then
    echo "Error: Podman is not installed. Please install it first."
    exit 1
fi

# Run the Builder Container
# Used environment variables compatible with the container's logic
echo "Pulling builder and generating ISO... (This may take a few minutes)"

sudo podman run --rm --privileged --volume .:/output \
  -e IMAGE_REPO="ghcr.io/${GITHUB_USER}" \
  -e IMAGE_NAME="${IMAGE_NAME}" \
  -e IMAGE_TAG="${TAG}" \
  -e VERSION="${FEDORA_VERSION}" \
  -e VARIANT="silverblue" \
  -e ISO_NAME="${ISO_NAME}" \
  ghcr.io/jasonn3/build-container-installer:latest

# Final Check
if [ -f "./$ISO_FILENAME" ]; then
    echo "----------------------------------------------------------------"
    echo "SUCCESS! ISO generated successfully."
    echo "You can now burn this file to a USB stick:"
    echo "  $ISO_FILENAME"
    echo "----------------------------------------------------------------"
else
    echo "----------------------------------------------------------------"
    echo "ERROR: ISO generation failed. Please check the logs above."
    echo "----------------------------------------------------------------"
    exit 1
fi
