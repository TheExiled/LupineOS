#!/bin/bash
echo "🐺 Forging 'OSINT' Container (Trace Labs)..."
# Using Kasm image as recommended for pre-built Trace Labs environment
# This image contains the full suite of OSINT tools.
distrobox create -n osint -i kasmweb/tracelabs:1.15.0 -Y

echo "OSINT Pack Ready. Run 'distrobox enter osint' to start."
