#!/usr/bin/env bash

echo "Setup Gitpod Local Companion..."
curl -OL https://gitpod.io/static/bin/gitpod-local-companion-darwin-arm64
chmod +x ./gitpod-local-companion-darwin-arm64
mv gitpod-local-companion-darwin-arm64 /usr/local/bin/gitpod-local-companion