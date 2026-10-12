# ROCK 4 SE Android TV 11

AOSP Android TV 11 for the Radxa ROCK 4 SE / RK3399.

This is a community build. It is not affiliated with or certified by Google or Radxa, and it does not include Google Apps.

## Status

The current working baseline uses the normal Rockchip RK3399 `tablet` BSP path and adds the Android TV pieces on top of it.

What is working in the current baseline:

- Android 11
- AOSP Android TV base
- ROCK 4 SE / ROCK 4B kernel and U-Boot configuration
- HDMI output
- Rockchip output manager
- Rockchip hardware video stack
- TV audio configuration

HDMI-CEC is not working yet. Enabling Android's `android.hardware.hdmi.cec` feature currently makes the board fail during boot and fall back to recovery.

There is no release-quality image from the current development branch yet. Older releases do not represent the current build and should be treated as experimental.

## Why the build uses the tablet BSP path

Rockchip selects different platform paths for `tablet`, `box` and `atv`.

On RK3399, the Rockchip `atv` and `box` paths fail to boot reliably in this tree. The normal `tablet` path does boot, so this project keeps that hardware/BSP path and sets:

```text
TARGET_BOARD_PLATFORM_PRODUCT=tablet
PRODUCT_CHARACTERISTICS=tv
```

The AOSP Android TV base and the Rockchip TV components are then added explicitly.

This is still Android TV 11. The word `tablet` here refers to the Rockchip BSP path, not the user interface.

## Source

The Android source comes from Radxa's Android 11 manifest:

```bash
repo init \
  -u https://github.com/radxa/manifests.git \
  -b Android11_Radxa_rk11 \
  -m rockchip-r-release.xml

repo sync -d --no-tags -j4
```

The hardware base is the ROCK 4B/RK3399 configuration used by the ROCK 4 SE:

```text
PRODUCT_KERNEL_CONFIG := rockchip_defconfig android-11.config rockpi_4b.config
PRODUCT_KERNEL_DTS := rk3399-rockpi-4b
PRODUCT_UBOOT_CONFIG := rockpi4b
```

## Build target

The public target is:

```text
rk3399_ROCK4SE_atv
```

The target name contains `atv`, but `BoardConfig.mk` explicitly forces the Rockchip platform product back to `tablet`. This avoids the broken RK3399 ATV BSP path while keeping a clear target name.

## Apply the project files

Copy:

```text
device/rockchip/rk3399/rk3399_ROCK4SE_atv/
```

into the Android source tree at the same path.

Apply:

```text
patches/device-rockchip-rk3399-AndroidProducts.patch
patches/external-rktoolbox-dr-g.patch
patches/hardware-rockchip-audio-force-box-hal.patch
```

The audio patch adds an explicit `ROCKCHIP_FORCE_BOX_HAL` switch. The product enables that switch without changing `TARGET_BOARD_PLATFORM_PRODUCT` to `box` or `atv`.

## Build environment

Build in the Docker image from `docker/Dockerfile`.

The Android/Rockchip tree contains old host tooling. Building directly on a modern Ubuntu host can fail in U-Boot and other legacy build scripts.

Example:

```bash
docker build -t rock4-atv11-build docker/

docker run --rm -it \
  -v /path/to/android/source:/src \
  -w /src \
  rock4-atv11-build \
  bash
```

Inside the container:

```bash
source build/envsetup.sh
lunch rk3399_ROCK4SE_atv-userdebug
./build.sh -UACKu
```

A successful GPT build ends with:

```text
Make gpt image ok!
```

The raw image is written under:

```text
rockdev/Image-rk3399_ROCK4SE_atv/gpt.img
```

## Flashing

The raw GPT image can be written to a microSD card with Balena Etcher, Rufus, `dd`, or another raw-image writer.

Flashing erases the selected card.

The first boot takes longer than later boots.

## Apps

Google Play Store is not included.

Android TV APKs such as Plex and Jellyfin can be installed with ADB. For a connected device:

```bash
adb install app.apk
```

To replace an installed APK while keeping its data:

```bash
adb install -r app.apk
```

## HDMI-CEC

CEC is disabled in the current baseline.

The main finding so far is simple: the TV build boots until `android.hardware.hdmi.cec.xml` advertises CEC support. Once that feature is advertised, Android starts its CEC framework path and the RK3399 build eventually falls back to recovery.

The HIDL service, device-type property, VINTF declaration and Rockchip legacy CEC HAL have all been tested in different combinations. None has fixed the feature-enabled boot failure yet.

See [docs/CEC-DEBUGGING.md](docs/CEC-DEBUGGING.md) for the test history.

## Hardware video decoding

The build keeps the Rockchip media stack used by the RK3399. H.264 and H.265/HEVC hardware decoding are part of the target, but codec and application testing is still ongoing.

## License

The files written for this repository are licensed under Apache-2.0 unless a file says otherwise.

Android, Rockchip, Radxa and other upstream code keep their original licenses.
