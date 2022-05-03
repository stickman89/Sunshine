#!/bin/bash -e

CMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE:-Release}"
SUNSHINE_EXECUTABLE_PATH="${SUNSHINE_EXECUTABLE_PATH:-/usr/bin/sunshine}"
SUNSHINE_ASSETS_DIR="${SUNSHINE_ASSETS_DIR:-/etc/sunshine}"


SUNSHINE_ROOT="${SUNSHINE_ROOT:-/root/sunshine}"
SUNSHINE_TAG="${SUNSHINE_TAG:-legacy_app-vars}"
SUNSHINE_GIT_URL="${SUNSHINE_GIT_URL:-https://github.com/loki-47-6F-64/sunshine.git}"


SUNSHINE_ENABLE_WAYLAND=${SUNSHINE_ENABLE_WAYLAND:-ON}
SUNSHINE_ENABLE_X11=${SUNSHINE_ENABLE_X11:-ON}
SUNSHINE_ENABLE_DRM=${SUNSHINE_ENABLE_DRM:-ON}
SUNSHINE_ENABLE_CUDA=${SUNSHINE_ENABLE_CUDA:-ON}

# For debugging, it would be usefull to have the sources on the host.
if [[ ! -d "$SUNSHINE_ROOT" ]]
then
    git clone --depth 1 --branch "$SUNSHINE_TAG" "$SUNSHINE_GIT_URL" --recurse-submodules "$SUNSHINE_ROOT"
fi

if [[ ! -d /root/sunshine-build ]]
then
	mkdir -p /root/sunshine-build
fi
cd /root/sunshine-build

cmake "-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE" "-DSUNSHINE_EXECUTABLE_PATH=$SUNSHINE_EXECUTABLE_PATH" "-DSUNSHINE_ASSETS_DIR=$SUNSHINE_ASSETS_DIR" "-DSUNSHINE_ENABLE_WAYLAND=$SUNSHINE_ENABLE_WAYLAND" "-DSUNSHINE_ENABLE_X11=$SUNSHINE_ENABLE_X11" "-DSUNSHINE_ENABLE_DRM=$SUNSHINE_ENABLE_DRM" "-DSUNSHINE_ENABLE_CUDA=$SUNSHINE_ENABLE_CUDA" "$SUNSHINE_ROOT"

make -j ${nproc}

./gen-deb
