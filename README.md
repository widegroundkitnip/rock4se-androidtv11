# ROCK 4 SE Android TV 11
Community-built AOSP Android TV 11 image for ROCK 4 SE / RK3399. Not affiliated with or certified by Google or Radxa. No Google Apps included.

Android TV 11 build for the Radxa ROCK 4 SE / RK3399.

The goal of this project is to provide a simple Android TV image for the ROCK 4 SE with support for TV-focused apps such as Plex and Jellyfin.

## Status

Current build target:

* Android 11
* AOSP Android TV
* Rockchip RK3399
* ROCK 4 SE / ROCK 4B hardware configuration
* HDMI output
* HDMI-CEC support
* Rockchip hardware video decoding

## Download

Prebuilt images will be available under **GitHub Releases**.
The goal is to provide a flashable image so users do not need to build Android themselves.

A release may contain:

```text
rock4se-androidtv11-vX.X.X.img.xz
SHA256SUMS
```

and, where useful:

```text
rock4se-androidtv11-vX.X.X-update.img
```

## Installation

> **Warning:** Flashing an image will overwrite the contents of the selected SD card or eMMC device. Back up anything important first.

### SD card

The easiest way to test the image is with a microSD card.

You will need:

* ROCK 4 SE
* microSD card
* SD card reader
* HDMI display
* Suitable power supply
* Ethernet or Wi-Fi

### Windows

1. Download the latest image from **Releases**.

2. If the file ends in `.img.xz`, either extract it with 7-Zip or flash the compressed image directly with a tool that supports it.

3. Install via a flashing tool such as:

   * Balena Etcher
   * Rufus

The first boot may take longer than later boots while Android initializes its data partition.

### Linux

After extracting the image, identify the SD card:

```bash
lsblk
```

Then flash it using `dd`:

```bash
sudo dd \
  if=rock4se-androidtv11-vX.X.X.img \
  of=/dev/sdX \
  bs=4M \
  status=progress \
  conv=fsync
```

Replace `/dev/sdX` with the correct device.

**Be careful:** selecting the wrong device will overwrite another disk.

### macOS

Identify the SD card:

```bash
diskutil list
```

Unmount it:

```bash
diskutil unmountDisk /dev/diskX
```

Flash the image:

```bash
sudo dd \
  if=rock4se-androidtv11-vX.X.X.img \
  of=/dev/rdiskX \
  bs=4m
```

Then eject it:

```bash
diskutil eject /dev/diskX
```

Balena Etcher can also be used instead.

### Rockchip `update.img`

Some releases may also provide a Rockchip:

```text
update.img
```

This format is intended for Rockchip flashing tools and can be useful for installing to eMMC or recovering a board.

Detailed `update.img` flashing instructions will be added once this release format has been tested on the ROCK 4 SE.

The raw/GPT image is recommended.

## Verify Download

Releases will include SHA-256 checksums where possible.

Linux:

```bash
sha256sum rock4se-androidtv11-vX.X.X.img.xz
```

macOS:

```bash
shasum -a 256 rock4se-androidtv11-vX.X.X.img.xz
```

PowerShell:

```powershell
Get-FileHash .\rock4se-androidtv11-vX.X.X.img.xz -Algorithm SHA256
```

Compare the result with the value in:

```text
SHA256SUMS
```

## Applications and sideloading

This build does not include Google Play Store. Apps such as Plex, Jellyfin and other Android TV applications can be installed manually using APK files and ADB.

ADB is used from another computer; you do not SSH into the Android TV device to install apps.

### 1. Install ADB on Windows

Download **Android SDK Platform-Tools for Windows** from Google:

https://developer.android.com/tools/releases/platform-tools

Extract the ZIP, for example to:

```text
C:\platform-tools
```

Open PowerShell in that directory and verify ADB works:

```powershell
.\adb.exe version
```

Linux and macOS users can also use Google's Platform-Tools package or their distribution's Android platform-tools package.

### 2. Enable developer options on the ROCK 4 SE

After Android TV has booted, open Settings and locate the Android build information. On Android TV this is typically under:

```text
Settings -> Device Preferences -> About -> Build
```

Press **Build** repeatedly until Developer options are enabled.

Then open **Developer options** and enable **USB debugging**. If the build exposes **Wireless debugging** or **Network debugging**, enable that as well for installation over your local network.

Menu names can vary slightly between Android TV builds.

### 3. Connect with ADB

#### Wireless debugging

Keep the Windows PC and ROCK 4 SE on the same local network.

If the device exposes classic network ADB on port 5555, connect with:

```powershell
.\adb.exe connect ROCK4SE_IP:5555
```

For example:

```powershell
.\adb.exe connect 192.168.1.123:5555
```

If Android displays a debugging authorization prompt on the TV, accept it.

Android 11 may instead show a **Wireless debugging** pairing screen with a pairing code and separate port numbers. In that case use the IP address and ports shown on the TV:

```powershell
.\adb.exe pair ROCK4SE_IP:PAIRING_PORT
.\adb.exe connect ROCK4SE_IP:ADB_PORT
```

Enter the pairing code shown on the TV when requested.

Check the connection:

```powershell
.\adb.exe devices
```

The ROCK 4 SE should appear as a connected device.

### 4. Install Plex, Jellyfin or another APK

Download the Android TV version of the application's APK from the project's official source or another source you trust.

Put the APK in your `platform-tools` directory and install it. For example:

```powershell
.\adb.exe install .\plex.apk
```

or:

```powershell
.\adb.exe install .\jellyfin.apk
```

For any other Android TV APK:

```powershell
.\adb.exe install .\app.apk
```

To update an already-installed app while keeping its app data:

```powershell
.\adb.exe install -r .\app.apk
```

After installation, the app should appear in the Android TV app list.

### Troubleshooting ADB

Check connected devices:

```powershell
.\adb.exe devices
```

Reconnect to a network device:

```powershell
.\adb.exe disconnect ROCK4SE_IP:5555
.\adb.exe connect ROCK4SE_IP:5555
```

Restart the local ADB service if needed:

```powershell
.\adb.exe kill-server
.\adb.exe start-server
```

If ADB reports the device as `unauthorized`, look at the TV and accept the debugging authorization prompt.

The main intended applications include:

* Plex
* Jellyfin
* Other Android TV compatible applications

## Building

Build scripts, device configuration and build instructions will be included in this repository.

The complete Android source tree is **not** stored here. It is downloaded from the upstream Android, Rockchip and Radxa repositories.

The Android 11 source is based on Radxa's Rockchip Android 11 manifest:

```bash
repo init \
  -u https://github.com/radxa/manifests.git \
  -b Android11_Radxa_rk11 \
  -m rockchip-r-release.xml

repo sync -d --no-tags -j4
```

The custom Android TV target is:

```text
rk3399_ROCK4SE_atv
```

Build target:

```bash
source build/envsetup.sh

lunch rk3399_ROCK4SE_atv-userdebug

./build.sh -UACKu
```

The build uses the ROCK 4 hardware configuration while enabling Rockchip's RK3399 Android TV platform.

Important hardware configuration includes:

```text
PRODUCT_KERNEL_DTS := rk3399-rockpi-4b
PRODUCT_UBOOT_CONFIG := rockpi4b
PRODUCT_KERNEL_CONFIG := rockchip_defconfig android-11.config rockpi_4b.config
```

Android TV mode uses:

```text
TARGET_BOARD_PLATFORM_PRODUCT := atv
```

which enables the AOSP Android TV base and Rockchip TV-specific components.

## Hardware

Target hardware:

* Radxa ROCK 4 SE
* Rockchip RK3399 / RK3399-T
* ARM64

ROCK 4B compatibility may also be possible, but the main target of this project is the ROCK 4 SE.

## Android TV

This project uses the **AOSP Android TV** framework.

It does not include:

* Google Play Services
* Google TV
* Google Play Store
* Google Assistant
* Proprietary Google Apps
* Google device certification

Applications such as Plex and Jellyfin can be installed separately.

This project should not be considered equivalent to a Google-certified Android TV or Google TV device.

## HDMI-CEC

The Rockchip Android TV configuration includes Android HDMI-CEC support.

The goal is to allow compatible TV remotes to control the Android TV interface through HDMI.

CEC functionality may vary between TVs and will be documented as hardware testing continues.

## Hardware Video Decoding

The RK3399 contains dedicated hardware video decoding support.

The build retains the Rockchip Android media stack and is intended to support hardware-accelerated playback, including H.264 and H.265/HEVC.

Actual codec and resolution support will be documented after testing with Plex, Jellyfin and local media files.

