#!/bin/bash

# Install necessary packages

echo "Installing the required dependencies and tools"

sudo apt-get install -y mtools libdw-dev kpartx libncurses5 libncurses-dev clang meson build-essential repo git-core gnupg flex bison gperf zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig fuse && pip install Jinja2 ply PyYAML
echo -e "\n\n" 
echo -e "\n\n" 
echo "Done installing dependecies"
echo -e "\n\n" 
echo -e "\n\n" 


echo "Installing the repo tool"
# Install Repo tool
mkdir -p ~/bin
PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

echo -e "\n\n" 
echo -e "\n\n" 


echo "Initializing and syncing the AOSP repository"
# Initialize AOSP repository
mkdir -p ~/aosp
cd ~/aosp
repo init -u https://android.googlesource.com/platform/manifest -b android-13.0.0_r75
curl -o .repo/local_manifests/manifest_brcm_rpi4.xml -L https://raw.githubusercontent.com/raspberry-vanilla/android_local_manifest/android-13.0/manifest_brcm_rpi4.xml --create-dirs
repo sync --force-sync -j8
echo -e "\n\n" 
echo "Done syncing AOSP"
echo -e "\n\n" 
echo -e "\n\n" 


echo "Iniializing and syncing kernel"
# Initialize kernel repository
cd ~/
mkdir kernel
cd kernel
cd ~/kernel
repo init -u https://android.googlesource.com/kernel/manifest -b common-android13-5.15-lts
curl --create-dirs -L -o .repo/local_manifests/manifest_brcm_rpi4.xml -O -L https://raw.githubusercontent.com/raspberry-vanilla/android_kernel_manifest/android-13.0/manifest_brcm_rpi4.xml
repo sync --force-sync -j8
echo -e "\n\n" 
echo "Done syncing kernel"
echo -e "\n\n" 
echo -e "\n\n" 
# Build kernel
echo "Starting to build kernel"
BUILD_CONFIG=common/build.config.rpi4 build/build.sh
echo -e "\n\n" 
echo "Building kernel complete"
 
# Copy kernel files to AOSP source tree
cp -rf out/common/arch/arm64/boot/* ~/aosp/device/brcm/rpi4-kernel/
echo -e "\n\n" 
echo "Copied required files from kernel to AOSP"
echo -e "\n\n" 

echo "Building Android 13"
cd ~/aosp
. build/envsetup.sh
lunch aosp_rpi4_car-userdebug
make bootimage systemimage vendorimage
./rpi4-mkimg.sh
echo -e "\n\n" 
echo -e "\n\n" 

echo "Find image at out/target/product/rpi4/"

echo "All commands executed successfully."


