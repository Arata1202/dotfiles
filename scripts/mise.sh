#!/bin/bash
set -eu
echo "Installing packages listed in mise/config.toml"
repo=$(cd "$(dirname "$0")/.." && pwd -P)
config="${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
if [[ ! "$config" -ef "$repo/mise/config.toml" ]]; then
    echo "Run make link before installing mise tools." >&2
    exit 1
fi
# Load the global configuration outside any home or checkout project.
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd -P "$work"
export MISE_CEILING_PATHS="$PWD" MISE_GLOBAL_CONFIG_FILE="$config"
MISE_PARANOID=1 mise trust "$config"
openssl_prefix=$(brew --prefix openssl@3)
export PKG_CONFIG_PATH="${openssl_prefix}/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export OPENSSL_CFLAGS="-I$openssl_prefix/include"
export OPENSSL_LIBS="-L$openssl_prefix/lib -lssl -lcrypto"

# asdf-php otherwise enables OpenSSL on macOS only when openssl@1.1 is installed.
if [[ -z ${PHP_CONFIGURE_OPTIONS:-} ]]; then
    PHP_CONFIGURE_OPTIONS="--with-libedit=$(brew --prefix libedit) --with-iconv=$(brew --prefix libiconv) --with-gettext=$(brew --prefix gettext)"
    for formula in gmp libsodium; do
        prefix=$(brew --prefix "$formula")
        if [[ -d "$prefix" ]]; then
            option=$formula
            [[ $formula != libsodium ]] || option=sodium
            PHP_CONFIGURE_OPTIONS+=" --with-$option=$prefix"
        fi
    done
fi
export PHP_CONFIGURE_OPTIONS="${PHP_CONFIGURE_OPTIONS} --with-openssl"
mise install
