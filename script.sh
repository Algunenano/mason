#!/usr/bin/env bash

MASON_NAME=mesa
MASON_VERSION=10.3.2
MASON_LIB_FILE=lib/libGL.so
MASON_PKGCONFIG_FILE=lib/pkgconfig/gl.pc

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    mason_download \
        http://ftp.de.debian.org/debian/pool/main/m/mesa/mesa_10.3.2.orig.tar.gz \
        8e3b99d5970287f4f9671b6b9cad127fc6e7c922

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/Mesa-10.3.2
}

function mason_compile {
    ./autogen.sh \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-shared \
        --with-gallium-drivers=svga,swrast \
        --disable-dri \
        --enable-xlib-glx \
        --enable-glx-tls \
        --with-llvm-prefix=/usr/lib/llvm-3.4 \
        --without-va

    make install
}

function mason_strip_ldflags {
    shift # -L...
    shift # -luv
    echo "$@"
}

function mason_ldflags {
    mason_strip_ldflags $(`mason_pkgconfig` --static --libs)
}

function mason_clean {
    make clean
}

mason_run "$@"
