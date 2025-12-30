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
sudo rm -rf ./iso-result  # lorax fails if output dir exists or is partial

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

    # Ensure loop devices exist (common issue in containers)
    for i in \$(seq 0 9); do
        if [ ! -e /dev/loop\$i ]; then
            mknod /dev/loop\$i b 7 \$i
        fi
    done

    echo '>>> [Container] Defining Kickstart for Container Install...'
    # We generate a minimal kickstart that tells Anaconda to install from our container.
    cat > /build/lupine.ks <<EOF
text
network --bootproto=dhcp
clearpart --all --initlabel
autopart
ostreecontainer --url=${IMAGE_REF} --no-signature-verification
EOF

    echo '>>> [Container] Running Lorax (Phase 1: Build Image)...'
    # Core Lorax command. Builds the raw installer (boot.iso).
    # We REMOVED '-ks' because lorax doesn't support it directly.
    lorax --product=LupineOS --version=41 --release=41 \
          --source=https://kojipkgs.fedoraproject.org/compose/41/latest-Fedora-41/compose/Everything/x86_64/os/ \
          --variant=Silverblue \
          --nomacboot \
          --volid=LupineOS-41 \
          --logfile=/output/lorax.log \
          --rootfs-size=4 \
          /output/iso-result

    echo '>>> [Container] Running mkksiso (Phase 2: Inject Configuration)...'
    # We now take the raw boot.iso and inject our OSTree kickstart to make it an installer.
    if [ -f /output/iso-result/images/boot.iso ]; then
        mkksiso --ks /build/lupine.ks \
                --cmdline "inst.ks=file:/ks.cfg" \
                /output/iso-result/images/boot.iso \
                /output/${ISO_NAME}
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
