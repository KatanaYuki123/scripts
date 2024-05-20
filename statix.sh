#!/bin/bash

export BUILD_USERNAME=KatanaYuki123
export BUILD_HOSTNAME=codespace
# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/StatiXOS/android_manifest.git -b udc-qpr2
git clone https://github.com/KatanaYuki123/local_manifests.git -b statix-spes .repo/local_manifests
/opt/crave/resync.sh

# Remove pixel headers to avoid conflicts
rm -rf hardware/google/pixel/kernel_headers/Android.bp

# Remove hardware/lineage/compat to avoid conflicts
rm -rf hardware/lineage/compat/Android.bp

# Sepolicy fix for imsrcsd
echo -e "${color}Switch back to legacy imsrcsd sepolicy${end}"
rm -rf device/qcom/sepolicy_vndr/legacy-um/qva/vendor/bengal/ims/imsservice.te
cp device/qcom/sepolicy_vndr/legacy-um/qva/vendor/bengal/legacy-ims/hal_rcsservice.te device/qcom/sepolicy_vndr/legacy-um/qva/vendor/bengal/ims/hal_rcsservice.te

# build rom
source build/envsetup.sh
lunch statix_spes-ap1a-userdebug
m installclean
mka bacon

# crave build command
# crave run --no-patch "rm -rf statix.sh && wget https://raw.githubusercontent.com/KatanaYuki123/scripts/main/statix.sh && chmod +x statix.sh && bash statix.sh"
