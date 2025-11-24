# Diagitizer - iOS Diagnostics Boot Utility

A macOS application for booting iOS devices into diagnostic mode via DFU mode exploitation. Supports iPhone 6 through iPhone X (A7-A11 chips).

## ⚠️ Important Notice
**Diagnostic files are NOT included.** You can obtain bootchain files from Purple Tool by @1nsane_dev.

## Features
- 🔧 Automatic `usbserial` boot argument configuration
- 🚀 One-click diagnostic mode booting (after setup)
- 📱 Support for iPhone 6 through iPhone X and compatible iPads
- 💡 Visual status feedback via LED indicators (DCSD)
- 🔄 Automatic device detection and exploit selection

## Supported Devices
- **A7 chips**: iPhone 6, 6 Plus, iPad mini 4 (eclipsa7000/7001)
- **A8/A8X chips**: iPhone 6S, 6S Plus, iPad 5, iPad Air 2 (eclipsa8000/8003)
- **A10/A10X chips**: iPhone 7, 7 Plus, iPad 6, iPad Pro 10.5"/12.9" (ipwndfu8010)
- **A11 chips**: iPhone 8, 8 Plus, iPhone X (ipwndfu8015)

See `Diagitizer/supportedDevices.json` for complete device list with CPID/BDID mappings.

## Setup Instructions

### 1. Prepare Bootchain Files
Place bootchain files in `~/Documents/diagitizer_bootchain/` with the following naming convention:

```
iBSS.<InternalName>.img4
iBoot.<InternalName>.img4
diag.<InternalName>.img4
```

**Example for iPhone X (D221):**
```
iBSS.D221.img4
iBoot.D221.img4
diag.D221.img4
```

### 2. DEADBEEF Placeholder Files
If your bootchain lacks an iBSS file, create a placeholder file containing only `0xDEADBEEF` bytes:
```
DE AD BE EF
```
The application will automatically skip sending DEADBEEF placeholder files.

![DEADBEEF Example](https://github.com/j4nf4b3l/Diagitizer-Open-Source/blob/master/DEADBEEF_Example.png)

### 3. Find Device Internal Names
Look up internal device names in:
- `Diagitizer/supportedDevices.json`
- [TheiphoneWiki](https://www.theiphonewiki.com/)

## Usage

1. Put your iOS device into **DFU mode**
2. Launch Diagitizer
3. Wait for device detection (status LED will cycle)
4. Click **"Go"** button when device is detected in DFU mode
5. Application will automatically:
   - Execute appropriate exploit for your device
   - Load bootchain stages (iBSS → iBoot → diag)
   - Set `usbserial=enabled` boot argument
   - Boot into diagnostics

## Adding New Devices

1. Add device entry to `Diagitizer/supportedDevices.json`:
```json
{
  "productName": "iPhone 7",
  "internalName": "D101",
  "cpid": 8010,
  "bdid": 8
}
```

2. If new chip type, add exploit binary to `Diagitizer/exploits/`
3. Add device routing logic in `ViewController.swift` `Go()` method

## Requirements
- macOS (Cocoa application)
- System Python 2.7 for ipwndfu exploits
- libusb (for Python-based exploits)

## Building
Open `Diagitizer.xcodeproj` in Xcode and build normally. All exploit binaries and utilities are bundled as resources.

## License
MIT License - Feel free to contribute and modify!

## Credits
- Exploit binaries: Various iOS security researchers
- ipwndfu: checkm8 implementation
- Purple Tool: @1nsane_dev
