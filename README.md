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

## Installation

Installation instructions:

## Building

Build scripts, device configuration and build instructions will be added to this repository.
The full Android source tree will not be stored in this repository. It is downloaded from the upstream Android, Rockchip and Radxa sources during setup.
Or here: 

## Hardware

Target hardware:

* Radxa ROCK 4 SE
* Rockchip RK3399 / RK3399-T
* ARM64

ROCK 4B compatibility may also be possible, but the main target of this project is the ROCK 4 SE.

## Android TV

This project uses the AOSP Android TV framework.

It does not include Google Play Services, Google TV, Google Play Store or other proprietary Google applications.

Applications such as Plex and Jellyfin can be installed separately.

## License

Original files and modifications in this repository are licensed under the Apache License 2.0 unless otherwise stated.

Android, the Linux kernel, U-Boot, Rockchip components and other third-party software remain under their respective upstream licenses.

See the included license and notice files for details.

## Credits

Based on work from:

* Android Open Source Project
* Rockchip
* Radxa

This is a community project and is not affiliated with or endorsed by Google, Rockchip or Radxa.
