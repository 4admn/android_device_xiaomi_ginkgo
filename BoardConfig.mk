#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
# Ignore overriding commands errors
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true
ALLOW_MISSING_DEPENDENCIES := true
# MiCam Board Yapılandırmaları ve SELinux
-include device/xiaomi/miuicamera-ginkgo/BoardConfig.mk
-include vendor/xiaomi/miuicamera-ginkgo/BoardConfigVendor.mk
# MiCam SELinux
BOARD_SEPOLICY_DIRS += device/xiaomi/miuicamera-ginkgo/sepolicy

# Inherit from sm6125-common
include device/xiaomi/sm6125-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/ginkgo

# MiuiCamera
-include device/xiaomi/miuicamera-ginkgo/BoardConfig.mk

# A/B
AB_OTA_UPDATER := false

# Assert
TARGET_OTA_ASSERT_DEVICE := ginkgo,willow

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := ginkgo

# Display
TARGET_SCREEN_DENSITY := 440

# Kernel
TARGET_KERNEL_CONFIG += vendor/ginkgo.config

# Dynamic Partitions (Retrofit Setup)
BOARD_SUPER_PARTITION_SIZE := 6442450944
BOARD_SUPER_PARTITION_GROUPS := ginkgo_dynapart
BOARD_GINKGO_DYNAPART_PARTITION_LIST := system vendor product system_ext
BOARD_GINKGO_DYNAPART_SIZE := 6438252544
BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor product system_ext
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 1610612736
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 1610612736
BOARD_SUPER_PARTITION_PRODUCT_DEVICE_SIZE := 2684354560
BOARD_SUPER_PARTITION_SYSTEM_EXT_DEVICE_SIZE := 536870912
BOARD_SUPER_PARTITION_METADATA_DEVICE := system

# File System Types
PARTITIONS := system vendor product system_ext
ifeq ($(WITH_GMS),true)
$(foreach p, $(call to-upper, $(PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
else
# Vanilla derlemelerde RAM ve performans optimizasyonu için ext4'e düşer
$(eval BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4)
$(eval BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs)
$(eval BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4)
$(eval BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4)
endif

$(foreach p, $(call to-upper, $(PARTITIONS)), \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))


# Partitions
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4831838208
BOARD_VENDORIMAGE_PARTITION_SIZE := 1610612736
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 402653184
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000

# NFC
ODM_MANIFEST_WILLOW_FILES := $(DEVICE_PATH)/configs/vintf/manifest_willow.xml
ODM_MANIFEST_SKUS += willow

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/properties/vendor.prop

# Recovery
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)

# Security patch level - V12.5.12.0.RCOEUXM
BOOT_SECURITY_PATCH := $(VENDOR_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Inherit from the proprietary version
include vendor/xiaomi/ginkgo/BoardConfigVendor.mk
