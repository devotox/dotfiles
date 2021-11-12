#!/usr/bin/env bash

# Install DisplayLink
# https://www.displaylink.com/downloads/macos

# Install PlayonMac
# https://www.playonmac.com/en/

# Install Tastyworks
# https://tastyworks.com/technology/

# Install Xtrafinder
# https://www.trankynam.com/xtrafinder/
# https://techstuffer.com/disable-sip-apple-silicon-m1/
# https://www.macworld.co.uk/how-to/mac/how-turn-off-mac-os-x-system-integrity-protection-rootless-3638975/
# csrutil disable
# csrutil enable [--without fs] (only if it didn't work)

# Run only after setting up Dropbox

./sudo-keepalive.sh

./config-setup.sh

./git-setup.sh

./fish-paths-setup.sh