#!/bin/bash

# Function to apply patches
apply_patches() {
    patch -N -p0 < patches/leveldb-1.22.patch
    patch -N -p0 < patches/libnbtplusplus-2.5.patch
    patch -N -p0 < patches/pugixml-1.14.patch
}

# Function to build and install
build_and_install() {
    rm -rf build
    mkdir -p build
    cd build

    cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS= -DCMAKE_C_FLAGS= ..

    make

    if [ "$INSTALL" = true ]; then
        make install
    else
        echo "Skipping 'make install' as requested."
    fi
}

# Check if the script is called with "--no-install" option
if [[ "$1" == "--no-install" ]]; then
    INSTALL=false
else
    INSTALL=true
fi

apply_patches
build_and_install
