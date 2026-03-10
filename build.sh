#! /bin/bash

set -e

fedora_version=43

sudo dnf config-manager addrepo --overwrite -y --from-repofile=https://developer.download.nvidia.com/compute/cuda/repos/fedora${fedora_version}/"$(uname -m)"/cuda-fedora${fedora_version}.repo

# Dev
sudo dnf install -y ninja mesa-libgbm-devel cuda-toolkit libappindicator-gtk3-devel

# Runtime
sudo dnf install -y libappindicator-gtk3

# rm -rf "build-test"
mkdir -p "build"

export cmake_args=(
    "-B=build"
    "-G=Ninja"
    "-S=."
    "-DBUILD_WERROR=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=/usr"
    "-DSUNSHINE_ASSETS_DIR=share/sunshine"
    "-DSUNSHINE_EXECUTABLE_PATH=/usr/bin/sunshine"
    "-DSUNSHINE_ENABLE_WAYLAND=ON"
    "-DSUNSHINE_ENABLE_X11=ON"
    "-DSUNSHINE_ENABLE_DRM=ON"
    "-DSUNSHINE_ENABLE_CUDA=ON"
    "-DCMAKE_CUDA_COMPILER:PATH=/usr/local/cuda/bin/nvcc"
)
cmake "${cmake_args[@]}"
ninja -C "build"

sudo mkdir -p /usr/share/sunshine
sudo cp ./build/assets/apps.json /usr/share/sunshine/apps.json
