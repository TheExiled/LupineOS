#!/bin/bash
set -eou pipefail

# --- Configuration ---
ISO_NAME="lupineos-41.iso"
IMAGE_REF="ostree-unverified-registry:ghcr.io/theexiled/lupineos:latest"
BUILD_DIR="./iso-build"

# --- Cleanup Function ---
cleanup() {
    echo ">> Cleaning up build directory..."
    sudo rm -rf "$BUILD_DIR"
}
trap cleanup EXIT

# --- Prep ---
echo "----------------------------------------------------------------"
echo "Starting NATIVE ISO Generation (Fedora 41 Base)"
echo "Target Image: $IMAGE_REF"
echo "Output ISO: $ISO_NAME"
echo "----------------------------------------------------------------"

if ! command -v podman &> /dev/null; then
    echo "Error: Podman not found."
    exit 1
fi

mkdir -p "$BUILD_DIR"

# --- The Build Command ---
# We run a privileged Fedora 41 container to perform the build.
# This ensures we have the latest Lorax tools and F41 repositories.
sudo podman run --rm --privileged \
    -v .:/output \
    -v "$BUILD_DIR":/build \
    fedora:41 bash -c "
    set -e
    
    echo '>>> [Container] Installing Build Tools (Lorax, OSTree)...'
    # Install packaging tools. 'lorax' includes the main logic.
    # 'ostree' needed for handling the container source.
    dnf install -y lorax ostree rpm-ostree git 

    echo '>>> [Container] Defining Kickstart for Container Install...'
    # We generate a minimal kickstart that tells Anaconda to install from our container.
    cat > /build/lupine.ks <<EOF
text
network --bootproto=dhcp
clearpart --all --initlabel
autopart
ostreecontainer --url=${IMAGE_REF} --no-signature-verification
EOF

    echo '>>> [Container] Running Lorax (This will take time)...'
    # Core Lorax command. We point it to official Fedora 41 repos.
    # We use --add-template-var to inject variables if needed, but basic args should suffice.
    lorax --product=LupineOS --version=41 --release=41 \
          --source=https://kojipkgs.fedoraproject.org/compose/41/latest-Fedora-41/compose/Everything/x86_64/os/ \
          --variant=Silverblue \
          --nomacboot \
          --volid=LupineOS-41 \
          --logfile=/output/lorax.log \
          --rootfs-size=4 \
          -ks /build/lupine.ks \
          /output/iso-result

    echo '>>> [Container] Moving ISO to output...'
    if [ -f /output/iso-result/images/boot.iso ]; then
        mv /output/iso-result/images/boot.iso /output/${ISO_NAME}
        echo '>>> [Container] Success!'
    else
        echo '>>> [Container] Error: boot.iso not found'
        exit 1
    fi
"

# --- Verification ---
if [ -f "./$ISO_NAME" ]; then
    echo "----------------------------------------------------------------"
    echo "SUCCESS! Native ISO generated: $ISO_NAME"
    echo "----------------------------------------------------------------"
    
    # Automation included from previous script
    echo "Generating Checksum..."
    sha256sum "$ISO_NAME" > ./docs/checksum.txt
    echo "Compressing (Background)..."
    xz -z -k -T0 "$ISO_NAME" &
else
    echo "ERROR: ISO generation failed."
    exit 1
fi
