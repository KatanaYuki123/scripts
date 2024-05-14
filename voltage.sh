#!/bin/bash

export BUILD_USERNAME=KatanaYuki123
export BUILD_HOSTNAME=codespace
# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/VoltageOS/manifest.git -b 14 --git-lfs
git clone https://github.com/KatanaYuki123/local_manifests.git -b voltage-spes .repo/local_manifests
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
lunch voltage_spes-ap1a-user
m installclean
mka bacon

# crave build command
# crave run --no-patch "rm -rf voltage.sh && wget https://raw.githubusercontent.com/KatanaYuki123/scripts/main/voltage.sh && chmod +x voltage.sh && bash voltage.sh"
