#!/usr/bin/env bash

MASON_NAME=android-ndk-arm-v7
MASON_VERSION=r10d
MASON_LIB_FILE=COPYING

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    if [ ${MASON_PLATFORM} = 'osx' ]; then
        mason_download \
            http://dl.google.com/android/ndk/android-ndk-r10d-darwin-x86_64.bin \
            8d65e748dda9741822a300e13b12960aa82ca58d
    elif [ ${MASON_PLATFORM} = 'linux' ]; then
        mason_download \
            http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin \
            95e64c8cf21d10a0a92abdafbee0df7808b063a1
    fi

    mason_setup_build_dir
    chmod +x ../.cache/${MASON_SLUG}
    ../.cache/${MASON_SLUG}

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/android-ndk-r10d
}

function mason_compile {
    rm -rf ${MASON_PREFIX}
    mkdir -p ${MASON_PREFIX}

    ${MASON_BUILD_PATH}/build/tools/make-standalone-toolchain.sh \
          --toolchain="arm-linux-androideabi-4.9" \
          --llvm-version="" \
          --package-dir="${MASON_BUILD_PATH}/package-dir/" \
          --install-dir="${MASON_PREFIX}" \
          --stl="libcxx" \
          --arch="arm" \
          --platform="android-9"
}

function mason_clean {
    make clean
}

mason_run "$@"
