#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if (( $EUID != 0 )); then
	printf "${RED}[x] sudo privileges not detected!!!\n"
	printf "This must be run as root. Use: ${NC}'sudo bash $0'\n"
 	exit
fi

py_version=$(python3 --version | cut -f2 -d " " | cut -f 1,2 -d ".")

pip_packs=( 
numpy 
scipy 
matplotlib 
pandas 
nose 
tk 
argparse 
imutils 
tqdm 
rich    
tensorflow
torch==1.11.0+cu113 
torchvision==0.12.0+cu113 
torchaudio==0.11.0+cu113
-f https://download.pytorch.org/whl/cu113/torch_stable.html
)

pip_packs_2_install=""
for package in ${pip_packs[@]}; do
    pip_packs_2_install="${pip_packs_2_install} ${package}"
done
pip install $pip_packs_2_install

mkdir /opt/opencv_build
cd /opt/opencv_build
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd opencv && mkdir -p build && cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_build/opencv_contrib/modules \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D WITH_CUDA=ON \
    -D BUILD_opencv_cudacodec=OFF \
    -D WITH_CUDNN=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D CUDA_ARCH_BIN=7.0 \
    -D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python${py_version}/dist-packages \
    -D BUILD_EXAMPLES=ON ..
make -j12