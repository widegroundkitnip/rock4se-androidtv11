# HDMI-CEC debugging notes

CEC is the main unresolved part of the ROCK 4 SE Android TV 11 build.

The stable TV baseline boots with CEC disabled. The failure starts when Android is told that the device supports `android.hardware.hdmi.cec`.

## What has been tested

| Test | Result |
| --- | --- |
| Full TV build, no CEC | boots |
| `ro.hdmi.device_type=4` only | boots |
| CEC HIDL 1.0 impl/service only | boots |
| HIDL + device type, no feature XML | boots |
| CEC feature XML only | fails |
| Feature XML + device type | fails |
| Feature XML + HIDL, no Rockchip legacy HAL | fails |
| Feature XML + HIDL + RK3399 VINTF declaration | fails |
| Full stack with `hdmi_cec.rk3399` | fails |
| Full stack with AudioService CEC initialization skipped | fails |

A separate PhoneWindowManager isolation test has also been prepared. These framework edits are diagnostic only and are not part of the normal product configuration.

## What the XML changes

The feature file contains:

```xml
<feature name="android.hardware.hdmi.cec" />
```

When PackageManager sees that feature, `SystemServer` starts `HdmiControlService`.

Android 11 then uses:

```text
HdmiControlService
  -> HdmiCecController
  -> android.hardware.tv.cec@1.0
  -> legacy HDMI-CEC HAL
  -> Rockchip hdmi_cec.rk3399
```

The AOSP HIDL 1.0 implementation loads the legacy HAL with `hw_get_module(HDMI_CEC_HARDWARE_MODULE_ID, ...)` and `hdmi_cec_open(...)`.

Rockchip's legacy implementation is in:

```text
hardware/rockchip/hdmicec/
```

and builds as:

```text
hdmi_cec.rk3399
```

## VINTF

The stock RK3399 manifests in this tree do not declare `android.hardware.tv.cec@1.0`. RK3328 does.

Adding this RK3328-style declaration to RK3399 did not fix the boot failure:

```xml
<hal format="hidl">
    <name>android.hardware.tv.cec</name>
    <transport>hwbinder</transport>
    <version>1.0</version>
    <interface>
        <name>IHdmiCec</name>
        <instance>default</instance>
    </interface>
</hal>
```

## Current plan

Return to the known-good CEC-disabled baseline and test additively.

The backend pieces should be added without the feature XML first. The feature XML should be the last switch enabled. That makes it easier to spot a bad dependency or a failure caused by a combination of components.

Temporary framework changes used during testing should not be committed to the normal build.
