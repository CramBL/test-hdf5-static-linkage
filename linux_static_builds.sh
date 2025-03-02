#!/usr/bin/env bash

set -euxo pipefail

RUSTFLAGS="--codegen target-feature=+crt-static" \
    cargo build --target x86_64-unknown-linux-musl

BIN_PATH="target/x86_64-unknown-linux-musl/debug/hdf5-static-linking"

ldd ${BIN_PATH}
set +eo pipefail
ldd ${BIN_PATH} | grep "statically linked"
set -eo pipefail

set +x
echo
echo "==========================="
echo "WITH HDF5"
echo "==========================="
echo
set -x

RUSTFLAGS="--codegen target-feature=+crt-static" \
    cargo build --target x86_64-unknown-linux-musl --features hdf5


ldd ${BIN_PATH}
ldd ${BIN_PATH} | grep "statically linked"
