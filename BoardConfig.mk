#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Ignore overriding commands errors
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true
ALLOW_MISSING_DEPENDENCIES := true

# MiCam Board Yapılandırmaları ve SELinux
-include device/xiaomi/miuicamera-ginkgo/BoardConfig.mk
-include vendor/xiaomi/miuicamera-ginkgo/BoardConfigVendor.mk
BOARD_SEPOLICY_DIRS += device/xiaomi/miuicamera-ginkgo/sepolicy

# Inherit from sm6125-common
include device/xiaomi/sm6125-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/ginkgo

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

# Partitions (Cache ve Recovery)
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 402653184
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000

# ====================================================
# RETROFIT DYNAMIC PARTITIONS VE EROFS
# ====================================================
BOARD_USE_DYNAMIC_PARTITIONS := true

# Mantıksal Bölümler (Super içine sanal olarak kurulacaklar)
PARTITIONS := system vendor product system_ext

ifeq ($(WITH_GMS),true)
PRODUCT_FS_COMPRESSION := 1
BOARD_EROFS_COMPRESSOR := lz4
BOARD_EROFS_PCLUSTER_SIZE := 262144

$(foreach p, $(call to-upper, $(PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
else
# GApps yoksa (Vanilla): ext4/erofs karma yapısını kullan
$(eval BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4)
$(eval BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs)
$(eval BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4)
$(eval BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4)
endif

# Kopyalama kuralları
$(foreach p, $(call to-upper, $(PARTITIONS)), \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Super Partition Toplam Boyutu 
BOARD_SUPER_PARTITION_SIZE := 6442450944

# Dinamik Grup Ayarları
BOARD_SUPER_PARTITION_GROUPS := ginkgo_dynapart
BOARD_GINKGO_DYNAPART_PARTITION_LIST := $(PARTITIONS)
BOARD_GINKGO_DYNAPART_SIZE := 6438252544

# FİZİKSEL BÖLÜMLER 
BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 4831838208
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 1610612736
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
# ====================================================

# NFC
ODM_MANIFEST_WILLOW_FILES := $(DEVICE_PATH)/configs/vintf/manifest_willow.xml
ODM_MANIFEST_SKUS += willow

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/properties/vendor.prop

# Sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Recovery
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)

# Security patch level
BOOT_SECURITY_PATCH := $(VENDOR_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Inherit from the proprietary version
include vendor/xiaomi/ginkgo/BoardConfigVendor.mk
include vendor/xiaomi/ginkgo/BoardConfigVendor.mk
