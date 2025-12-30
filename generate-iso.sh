#!/bin/bash

# Configuration Variables
# Configuration Variables
GITHUB_USER="theexiled" # Must be lowercase for GHCR
IMAGE_NAME="lupineos"
TAG="latest"
FEDORA_VERSION="41"
ISO_FILENAME="lupineos-${FEDORA_VERSION}.iso"

echo "----------------------------------------------------------------"
echo "Starting ISO Generation for: ghcr.io/${GITHUB_USER}/${IMAGE_NAME}:${TAG}"
echo "Target Fedora Version: $FEDORA_VERSION"
echo "Output ISO: $(pwd)/$ISO_FILENAME"
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
  ghcr.io/jasonn3/build-container-installer:latest \
  --image-repo "ghcr.io/${GITHUB_USER}" \
  --image-name "${IMAGE_NAME}" \
  --image-tag "${TAG}" \
  --version "${FEDORA_VERSION}" \
  --variant "silverblue" \
  --iso-name "${ISO_FILENAME}"

# Final Check
if [ -f "./$ISO_FILENAME" ]; then
    echo "----------------------------------------------------------------"
    echo "SUCCESS! ISO generated successfully."
    echo "You can now burn this file to a USB stick:"
    echo "  $ISO_FILENAME"
    
    # ---------------------------------------------------------
    # AUTOMATION: Update Website Assets
    # ---------------------------------------------------------
    echo "Generating Checksum for Website..."
    sha256sum "$ISO_FILENAME" > ./docs/checksum.txt
    
    # Optional: If you want to compress it for GitHub Release
    echo "Compressing for Release (Background)..."
    xz -z -k -T0 "$ISO_FILENAME" & 
    
    echo "Website 'docs/checksum.txt' updated."
    echo "----------------------------------------------------------------"
else
    echo "----------------------------------------------------------------"
    echo "ERROR: ISO generation failed. Please check the logs above."
    echo "----------------------------------------------------------------"
    exit 1
fi
