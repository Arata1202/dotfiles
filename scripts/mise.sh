#!/bin/bash
set -eu
echo "Installing packages listed in mise/config.toml"
repo=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd -P)
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
export MISE_PARANOID=1
mise trust "$config"
required_prefix() {
    local prefix
    prefix=$(brew --prefix "$1") || return 1
    if [[ ! -d "$prefix" ]]; then
        echo "Missing Homebrew formula: $1" >&2
        return 1
    fi
    printf '%s\n' "$prefix"
}
openssl_prefix=$(required_prefix openssl@3)
export PKG_CONFIG_PATH="${openssl_prefix}/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export OPENSSL_CFLAGS="-I$openssl_prefix/include"
export OPENSSL_LIBS="-L$openssl_prefix/lib -lssl -lcrypto"

# asdf-php otherwise enables OpenSSL on macOS only when openssl@1.1 is installed.
if [[ -z ${PHP_CONFIGURE_OPTIONS:-} ]]; then
    libedit=$(required_prefix libedit)
    libiconv=$(required_prefix libiconv)
    gettext=$(required_prefix gettext)
    PHP_CONFIGURE_OPTIONS="--with-libedit=$libedit --with-iconv=$libiconv --with-gettext=$gettext"
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
