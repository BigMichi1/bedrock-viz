#!/bin/bash

patch -p0 < patches/leveldb-1.22.patch
patch -p0 < patches/pugixml-disable-install.patch

rm -rf build
mkdir -p build
cd build

cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DBUILD_DOCS=OFF -DCATKIN_ENABLE_TESTING=OFF -DBUILD_DOCUMENTATION=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS= -DCMAKE_C_FLAGS= ..
make
make install
