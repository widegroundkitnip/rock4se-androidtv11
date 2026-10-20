# ROCK 4 SE Android TV 11

Community-built AOSP Android TV 11 for the Radxa ROCK 4 SE / RK3399.

This project is not affiliated with or certified by Google or Radxa. Google Apps, Google Play Services and the Play Store are not included.

## Current release

**v1.0.4** is the current tested image:

- [Download `rock4se-androidtv11-v1.0.4.img.xz`](https://github.com/widegroundkitnip/rock4se-androidtv11/releases/download/v1.0.4/rock4se-androidtv11-v1.0.4.img.xz)
- [Release notes](https://github.com/widegroundkitnip/rock4se-androidtv11/releases/tag/v1.0.4)

SHA-256:

```text
9acd0f5fc915164388f1aac5f866bbfbd46a3be230ae6856751a721695accc74  rock4se-androidtv11-v1.0.4.img.xz
90cd49548c6c8784ae81c6bce811848907ef76c4728aa98c48ec5ccb6aa37590  rock4se-androidtv11-v1.0.4.img
```

The uncompressed image is 4,372,579,840 bytes.

## Changes in v1.0.4

- **Fixed display glitch & tearing on idle:** Disabled the phantom internal 720p MIPI-DSI panel (`&dsi`, `simple-panel-dsi`, `&dsi1`) in the device tree that caused dual-display VOP buffer contention.
- **Configured HDMI as primary native display:** Explicitly configured `vendor.hwc.device.primary=HDMI-A` and `vendor.hwc.compose_policy=6` for clean VOP hardware plane compositing at 1080p@60Hz.

## What works

The image has been tested on a ROCK 4 SE:

- Android 11 / API 30
- AOSP Android TV interface
- Leanback launcher and Leanback keyboard
- TV provisioning and TV Settings
- HDMI output and TV audio configuration
- HDMI-CEC service and remote-control navigation
- Rockchip RK3399 hardware video stack
- Wi-Fi hardware detection
- Bluetooth enabled and running
- Stable framework boot with `sys.boot_completed=1`

The build uses the Rockchip ATV product path while retaining the ROCK 4 SE kernel, device tree, U-Boot and hardware support.

## What is not included

- Google Apps, GTVS, Google Play Services or Play Store
- Phone launcher or phone Setup Wizard
- Telephony, RIL or APN configuration
- Touchscreen or fake-touch device declarations
- Rockchip tablet launcher and bundled tablet apps

## Install Plex or Jellyfin

This image has no Play Store. Download an Android TV APK on another computer from [Plex](https://forums.plex.tv/t/plex-for-mobile-tvs-android-mobile-ios-android-tv-tvos-fire-tv/909610) or [Jellyfin](https://github.com/jellyfin/jellyfin-androidtv/releases), then sideload it:

```bash
adb install -r Plex.apk
adb install -r Jellyfin.apk
```

Use a standalone Android TV `arm64-v8a` or universal APK, not an APK bundle.

## Verify the download

On Linux:

```bash
sha256sum rock4se-androidtv11-v1.0.4.img.xz
```

On macOS:

```bash
shasum -a 256 rock4se-androidtv11-v1.0.4.img.xz
```

The expected compressed-file checksum is:

```text
9acd0f5fc915164388f1aac5f866bbfbd46a3be230ae6856751a721695accc74
```

To verify the image content without keeping a second 4.1 GiB file:

```bash
xz -dc rock4se-androidtv11-v1.0.4.img.xz | sha256sum
```

Expected uncompressed checksum:

```text
90cd49548c6c8784ae81c6bce811848907ef76c4728aa98c48ec5ccb6aa37590
```

## Flashing

The release asset is an XZ-compressed raw GPT disk image. Balena Etcher can normally open the `.img.xz` file directly. Alternatively, decompress it first:

```bash
xz -dk rock4se-androidtv11-v1.0.4.img.xz
```

Then write `rock4se-androidtv11-v1.0.4.img` with Etcher, Rufus, Raspberry Pi Imager or another raw-image writer.

> [!WARNING]
> Flashing erases the selected drive. Verify that the target is the removable microSD card, not your computer's system disk.

The first boot takes longer than later boots.

## Runtime verification

The tested image reached boot completion in about 62 seconds. `system_server` remained stable beyond the failure interval seen in earlier development images. The sensor HAL and HDMI-CEC HAL both registered successfully.

The active Home activity was the AOSP sample Leanback launcher, and LeanbackIME was the active keyboard. Runtime inspection found no phone, telephony, touchscreen or fake-touch declarations.

### UART caution

Avoid sending interactive UART commands during the first two to three minutes of boot. One early-boot diagnostic attempt triggered a stack overflow in Rockchip's FIQ UART debugger. Passive UART capture and post-boot commands worked normally.

## Source base

The Android source starts from Radxa's Android 11 manifest:

```bash
repo init \
  -u https://github.com/radxa/manifests.git \
  -b Android11_Radxa_rk11 \
  -m rockchip-r-release.xml

repo sync -d --no-tags -j4
```

The v1.0.3 image was built with:

```text
rk3399_ROCK4SE_atvbase_test-userdebug
```

and the Rockchip ATV product mode:

```text
TARGET_BOARD_PLATFORM_PRODUCT=atv
PRODUCT_CHARACTERISTICS=tv
```

The hardware base remains:

```text
PRODUCT_KERNEL_CONFIG := rockchip_defconfig android-11.config rockpi_4b.config
PRODUCT_KERNEL_DTS := rk3399-rockpi-4b
PRODUCT_UBOOT_CONFIG := rockpi4b
```

Builds should run inside the environment defined by [`docker/Dockerfile`](docker/Dockerfile), because the Rockchip tree contains legacy host tools that can fail on modern Linux distributions.

> [!NOTE]
> The device files and patches currently stored in this repository describe the older v1.0.0 hybrid baseline. They are retained as historical development material and do **not** yet reproduce the v1.0.3 release image. The downloadable v1.0.3 image and its checksums are authoritative for this release.

## HDMI-CEC

v1.0.3 includes:

- `android.hardware.hdmi.cec.xml`
- the Rockchip CEC service and implementation
- a VINTF declaration for `android.hardware.tv.cec@1.0::IHdmiCec/default`

The service registers successfully and CEC remote navigation has been tested. [`docs/CEC-DEBUGGING.md`](docs/CEC-DEBUGGING.md) records the earlier failure investigation and should be read as historical debugging notes.

## Hardware video decoding

The image retains the Rockchip RK3399 media stack. H.264 and H.265/HEVC hardware decoding support is included, although application-specific codec compatibility can vary.

## License

Files written for this repository are licensed under Apache-2.0 unless a file says otherwise.

Android, Rockchip, Radxa and other upstream code retain their original licenses.
