#!/usr/bin/env bash

MASON_NAME=openfst
MASON_VERSION=1.6.7
MASON_LIB_FILE=lib/libfst.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://www.openfst.org/twiki/pub/FST/FstDownload/${MASON_NAME}-${MASON_VERSION}.tar.gz \
        aad8478b9a91d54f2e395c6590270b32c3b9cf46

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/${MASON_NAME}-${MASON_VERSION}
}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -O3 -DNDEBUG"
    export CXXFLAGS="${CXXFLAGS:-} -std=c++11 -O3 -DNDEBUG"
    if [[ $(uname -s) == 'Darwin' ]]; then
        export LDFLAGS="${LDFLAGS:-} -stdlib=libc++"
    fi

    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking \
        --enable-compact-fsts \
        --enable-compress \
        --enable-const-fsts \
        --enable-far \
        --enable-linear-fsts \
        --enable-lookahead-fsts \
        --enable-mpdt \
        --enable-ngram-fsts \
        --enable-pdt \
        --enable-special \
        --enable-python \
        --enable-script \
        --enable-bin


    make -j${MASON_CONCURRENCY}
    make install
}

function mason_cflags {
    echo "-I${MASON_PREFIX}/include"
}

function mason_ldflags {
    :
}

function mason_static_libs {
    echo ${MASON_PREFIX}/${MASON_LIB_FILE}
}

function mason_clean {
    make clean
}

mason_run "$@"
