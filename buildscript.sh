#!/bin/bash

patch -N -p0 < patches/leveldb-1.22.patch
patch -N -p0 < patches/libnbtplusplus-2.5.patch
patch -N -p0 < patches/pugixml-1.14.patch

rm -rf build
mkdir -p build
cd build

cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS= -DCMAKE_C_FLAGS= ..
make
make install
