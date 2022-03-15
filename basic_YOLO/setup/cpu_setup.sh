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

apt update
apt upgrade -y
rpi-update

apt_packs-(
git python3 
python3-dev 
x264 
build-essential 
ffmpeg 
opencv-doc 
python3-numpy 
python3-scipy 
python3-matplotlib 
python3-pandas 
python3-nose 
python3-tk 
python3-opencv
)

apt_packs_2_install=""
for package in ${apt_packs[@]}; do
    apt_packs_2_install="${apt_packs_2_install} ${package}"
done

apt update

apt install -fy $apt_packs_2_install

apt --fix-broken install

echo -e "\n\n\n Testing OpenCV \n\n\n"

test_cv=`cat <<EOF
import cv2
print(cv2.__version__)
EOF`
python3 -c "$test_cv"