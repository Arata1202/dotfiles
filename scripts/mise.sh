#!/bin/bash
set -eu
echo "Installing packages listed in mise/config.toml"
cd ~
mise install
