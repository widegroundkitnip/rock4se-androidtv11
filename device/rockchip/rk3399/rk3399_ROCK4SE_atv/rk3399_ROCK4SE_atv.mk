#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_SHIPPING_API_LEVEL := 30
PRODUCT_DTBO_TEMPLATE := $(LOCAL_PATH)/dt-overlay.in
PRODUCT_BOOT_DEVICE := fe330000.sdhci,fe320000.dwmmc

include device/rockchip/common/build/rockchip/DynamicPartitions.mk
include device/rockchip/rk3399/rk3399_ROCK4SE_atv/BoardConfig.mk
include device/rockchip/common/BoardConfig.mk

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/rockchip/rk3399/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)

PRODUCT_CHARACTERISTICS := tv

PRODUCT_NAME := rk3399_ROCK4SE_atv
PRODUCT_DEVICE := rk3399_ROCK4SE_atv
PRODUCT_BRAND := rockchip
PRODUCT_MODEL := rk3399-Android11
PRODUCT_MANUFACTURER := rockchip
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PACKAGES += \
    SoundRecorder

PRODUCT_PACKAGE_OVERLAYS += \
    device/rockchip/rk3399/rk3399_ROCK4SE_atv/overlay \
    device/rockchip/rk3399/screen_always_on_overlay

PRODUCT_COPY_FILES += \
    vendor/rockchip/common/phone/etc/apns-full-conf.xml:system/etc/apns-conf.xml \
    vendor/rockchip/common/phone/etc/spn-conf.xml:system/etc/spn-conf.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.version=1.0.0 \
    ro.product.ota.host=192.168.1.1:8888 \
    ro.sf.lcd_density=280 \
    vendor.hwc.device.primary=HDMI-A \
    vendor.hwc.device.extend=DSI \
    persist.vendor.framebuffer.main=1920x1080@60

# Use AOSP Android TV on top of the stable RK3399 tablet BSP path.
$(call inherit-product, device/google/atv/products/atv_base.mk)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AllAudio.mk)

PRODUCT_PACKAGES += \
    DocumentsUI \
    ATVContentProvider

# The AOSP ATV overlay is not compatible with Rockchip's tablet RRO enforcement.
PRODUCT_ENFORCE_RRO_TARGETS :=

PRODUCT_COPY_FILES += \
    device/rockchip/common/resolution_white.xml:/system/usr/share/resolution_white.xml \
    device/rockchip/common/tv/permissions/privapp-permissions-tv-common.xml:system/etc/permissions/privapp-permissions-tv-common.xml

PRODUCT_PACKAGES += \
    rockchip.hardware.outputmanager@1.0-impl \
    rockchip.hardware.outputmanager@1.0-service

USE_CUSTOM_AUDIO_POLICY := 1
ROCKCHIP_FORCE_BOX_HAL := true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.enable.remotecontrol=true \
    ro.pms.multithreadscan=true

TARGET_RECOVERY_OVERSCAN_PERCENT := 2
TARGET_BASE_PARAMETER_IMAGE ?= device/rockchip/common/baseparameter/baseparameter.img
DEVICE_FRAMEWORK_MANIFEST_FILE := device/rockchip/common/manifest_framework_override.xml

PRODUCT_PACKAGES += \
    saveBaseParameter

ifeq ($(strip $(BOARD_WITH_RKTOOLBOX)),true)
$(call inherit-product-if-exists, external/rktoolbox/rktoolbox.mk)
endif

# HDMI-CEC is deliberately not advertised here yet.
# Enabling android.hardware.hdmi.cec currently causes the RK3399 build to
# fail during boot and fall back to recovery.
