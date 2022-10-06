git submodule sync --recursive
git submodule update --init --recursive --jobs 0

pushd emsdk
./emsdk install latest
./emsdk activate latest
popd

pushd qt5
git checkout 6.4
./init-repository

mkdir build_host
pushd build_host
../configure -opensource -confirm-license -prefix $PWD
cmake --build . --parallel
popd
popd

source emsdk/emsdk_env.sh
pushd qt5
mkdir build_wasm
cd build_wasm
../configure -qt-host-path ../build_host/qtbase \
  -xplatform wasm-emscripten \
  -prefix $PWD \
  -nomake examples \
  -feature-thread \
  -opensource \
  -confirm-license

cmake --build . --parallel

#  -Qt6HostInfo_DIR=/home/mlevental/dev_projects/LyxWasm/qt5/build_host/qtbase/lib/cmake \
