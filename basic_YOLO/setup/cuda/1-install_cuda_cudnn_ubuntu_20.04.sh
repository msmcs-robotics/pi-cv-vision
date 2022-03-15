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

apt_packs=(
build-essential 
cmake 
pkg-config 
unzip 
yasm 
git 
checkinstall 
libjpeg-dev 
libpng-dev 
libtiff-dev 
libavcodec-dev 
libavformat-dev 
libswscale-dev 
libavresample-dev 
libgstreamer1.0-dev 
libgstreamer-plugins-base1.0-dev 
libxvidcore-dev 
x264 
libx264-dev 
libfaac-dev 
libmp3lame-dev 
libtheora-dev  
libfaac-dev 
libmp3lame-dev 
libvorbis-dev 
libopencore-amrnb-dev 
libopencore-amrwb-dev 
libdc1394-22 
libdc1394-22-dev 
libxine2-dev 
libv4l-dev 
v4l-utils 
libgtk-3-dev 
libgtk2.0-dev 
python3-dev 
python3-pip 
python3-testresources 
libtbb-dev 
libprotobuf-dev 
protobuf-compiler 
libgoogle-glog-dev 
libgflags-dev 
libgphoto2-dev 
libeigen3-dev 
libhdf5-dev 
doxygen
)

### Install Apt Packages (Ubuntu 20.04)

apt_packs_2_install=""
for package in ${apt_packs[@]}; do
    apt_packs_2_install="${apt_packs_2_install} ${package}"
done
apt update

apt install -fy $apt_packs_2_install

apt --fix-broken install

reboot now

### Install Cuda (Ubuntu 20.04)

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
apt-get update
apt-get -fy install cuda 
apt install -fy libcudnn8 libcudnn8-dev

### If possible missing firmware

mkdir rtl8125b_fw
cd rtl8125b_fw
wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rtl_nic/rtl8125b-2.fw
wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rtl_nic/rtl8168fp-3.fw
sudo cp *.fw /lib/firmware/rtl_nic/
sudo update-initramfs -u

