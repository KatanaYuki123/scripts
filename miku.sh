#!/bin/bash

export BUILD_USERNAME=KatanaYuki123
export BUILD_HOSTNAME=codespace
# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/Miku-UI/manifesto -b Udon_v2
git clone https://github.com/KatanaYuki123/local_manifests.git -b miku-spes .repo/local_manifests
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
lunch miku_spes-ap1a-user
m installclean
make diva

# crave build command
# crave run --no-patch "rm -rf voltage.sh && wget https://raw.githubusercontent.com/KatanaYuki123/scripts/main/voltage.sh && chmod +x voltage.sh && bash voltage.sh"
