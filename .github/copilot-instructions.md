# Diagitizer Copilot Instructions

## Project Overview
Diagitizer is a macOS Cocoa application that boots iOS devices into diagnostic mode by exploiting DFU mode vulnerabilities. It supports iPhone 6 through iPhone X (A7-A11 chips) by executing device-specific exploits and loading custom bootchains.

## Architecture

### Core Components
- **ViewController.swift**: Main application logic handling device detection, exploitation, and bootchain loading
- **AppDelegate.swift**: Standard macOS app delegate (minimal customization)
- **supportedDevices.json**: Device database mapping CPID/BDID to internal names and product names
- **Binary exploits**: Pre-compiled exploit binaries (`eclipsa7000`, `eclipsa7001`, `eclipsa8000`, `eclipsa8003`) and Python-based exploits (`ipwndfu8010`, `ipwndfu8015`)
- **System utilities**: `irecovery` for USB device communication, `dcsd` for status LED control

### Critical Workflow
1. **Device Detection** (`deviceDetect`): Polls `irecovery -q` every second to identify connected devices by CPID/BDID
2. **Exploitation**: Routes to chip-specific exploit based on `connectedDeviceModel` (e.g., N61→eclipsa7000, D221→ipwndfu8015)
3. **Bootchain Loading** (`getBootchain`): Sequentially sends iBSS→iBoot→diag from `~/Documents/diagitizer_bootchain/`
4. **Boot Args**: Sets `usbserial=enabled` via irecovery commands before booting diagnostics

### Device-Specific Routing
```swift
// Example pattern used throughout ViewController
if connectedDeviceModel == "N61" || connectedDeviceModel == "N56" {
    eclipsa7000() // iPhone 6/6+ use A7 chip exploit
}
if connectedDeviceModel == "D221" {
    ipwndfu8015() // iPhone X uses A11 checkm8 exploit
}
```

## Key Conventions

### Binary Execution Pattern
All exploits return `Int32` termination status. Bash-based exploits (`ipwndfu*`) execute via `/bin/bash`, while compiled exploits run directly:
```swift
task.launchPath = Bundle.main.path(forResource: "eclipsa8000", ofType: "", inDirectory: "exploits/")
task.waitUntilExit()
return task.terminationStatus
```

### DEADBEEF Placeholder Files
Missing bootchain stages use placeholder files containing `0xDEADBEEF` bytes. Code skips sending these:
```swift
if iBSS_data != Data([0xDE,0xAD,0xBE,0xEF]) {
    iRecovery("-f", path: boot1_path.path)
}
```

### Progress Indication
- **DCSD LED control**: `DCSDStatus(0-4)` controls external status LEDs
- **Progress bar**: `FlashProgress.doubleValue = 0.0-1.0` tracks exploitation/flashing stages
- **UI updates**: All UI changes wrapped in `DispatchQueue.main.async` from background threads

### Error Handling Philosophy
Exploitation uses 5-second timeouts. On failure, resets `deviceDetectionHandler = true` and shows status via `DCSDStatus(3)` (error state).

## Development Workflows

### Building
Open `Diagitizer.xcodeproj` in Xcode. No external build system required—standard Xcode build process.

### Testing Devices
Add new devices to `supportedDevices.json` with:
```json
{
  "productName": "iPhone 7",
  "internalName": "D101",
  "cpid": 8010,
  "bdid": 8
}
```
Device detection automatically matches against this database.

### Adding Exploits
1. Place binary in `Diagitizer/exploits/` and add to Xcode project as resource
2. Create exploit function following existing pattern (5-sec timeout for stability)
3. Add device routing in `Go()` method matching CPID range to exploit

## External Dependencies

### Python Exploits (ipwndfu)
- **ipwndfu8010/ipwndfu8015**: Standalone checkm8 implementations for A10/A11 chips
- **Required**: System Python 2.7 (`/usr/bin/python`) and `libusb`
- **Execution**: `exploit.sh` wrapper scripts invoke `ipwndfu -p` then `rmsigchks`

### irecovery CLI
Pre-compiled binary for USB recovery mode communication. Invoked with:
- `-q`: Query device info (CPID/BDID/MODE)
- `-f <path>`: Send IMG4 file
- `-c <cmd>`: Execute iBoot commands (`setenv`, `saveenv`, `go`)

### User-Provided Bootchains
Users must manually place bootchain files in `~/Documents/diagitizer_bootchain/` with naming: `iBSS.<InternalName>.img4`, `iBoot.<InternalName>.img4`, `diag.<InternalName>.img4`

## Common Pitfalls

1. **Case sensitivity**: Internal names (N61, D221) must match exactly—case-sensitive matching throughout
2. **Background threads**: Exploitation runs on `DispatchQueue.global(qos: .background)`—never block main thread
3. **Device state**: Only enable "Go" button when device is in DFU mode (`mode == "DFU"`)
4. **CPID/BDID collisions**: Some devices share CPID but differ in BDID (e.g., iPhone X has BDID 6 and 14)

## File Locations
- Device database: `Diagitizer/supportedDevices.json`
- Main logic: `Diagitizer/ViewController.swift`
- Exploit binaries: `Diagitizer/exploits/*`
- User bootchains: `~/Documents/diagitizer_bootchain/`
