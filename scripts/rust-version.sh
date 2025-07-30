#!/bin/bash

# URL of the Cargo.toml file
CARGO_TOML_URL="https://github.com/Azure/azure-sdk-for-rust/raw/main/Cargo.toml"

# Download Cargo.toml to a temporary file
TMP_FILE=$(mktemp)
curl -sSL "$CARGO_TOML_URL" -o "$TMP_FILE"

# Extract rust-version from [workspace.package] section
RUST_VERSION=$(awk '
  $0 ~ /^\[workspace\.package\]/ { in_section=1; next }
  in_section && $0 ~ /^rust-version/ {
    gsub(/"/, "", $3);
    print $3;
    exit
  }
' "$TMP_FILE")

# Remove temporary file
rm "$TMP_FILE"

# Output the Rust version
echo "$RUST_VERSION"