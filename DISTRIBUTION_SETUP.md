# TrackWeight Distribution Setup

This guide explains how to set up code signing and notarization for distributing TrackWeight outside the Mac App Store.

## Prerequisites

### 1. Apple Developer Account
- **Paid Apple Developer Program membership** ($99/year)
- Enrolled at: https://developer.apple.com/programs/

### 2. Homebrew (for create-dmg)
- Install Homebrew: https://brew.sh
- The script will automatically install `create-dmg` via Homebrew if needed

### 3. Developer ID Certificates
You need two certificates in your macOS Keychain:

#### Developer ID Application Certificate
- For code signing apps
- Download from: Apple Developer → Certificates → Developer ID Application

#### Developer ID Installer Certificate  
- For signing installer packages
- Download from: Apple Developer → Certificates → Developer ID Installer

### 3. App-Specific Password
- Required for notarization
- Generate at: https://appleid.apple.com/account/manage
- Go to "App-Specific Passwords" section
- Create password with name "TrackWeight Notarization"

## Setup Steps

### 1. Install Certificates
1. Download both Developer ID certificates from Apple Developer portal
2. Double-click each certificate to install in Keychain Access
3. Verify they appear in "My Certificates" with your team name

### 2. Configure the Script
Edit `build_and_notarize.sh` and update these variables:

```bash
# Your Apple ID email
APPLE_ID="your-email@example.com"

# App-specific password you generated
APP_PASSWORD="your-app-specific-password"

# Your team ID (already set: 9ZRLG6277G)
TEAM_ID="9ZRLG6277G"
```

### 3. Verify Your Team ID
```bash
# Check your team ID
xcrun altool --list-providers -u "your-apple-id" -p "your-app-password"
```

## Running the Build Script

### Basic Usage
```bash
./build_and_notarize.sh
```

### What the Script Does
1. **Builds** the app in Release configuration
2. **Code signs** with Developer ID certificate
3. **Creates** distribution entitlements (disables sandbox)
4. **Exports** the signed app
5. **Verifies** code signing
6. **Creates ZIP** for notarization
7. **Submits** to Apple for notarization
8. **Waits** for notarization approval
9. **Staples** notarization ticket to app
10. **Creates professional DMG** installer with custom styling
11. **Verifies** final app with Gatekeeper

### Output Files
The script creates in `build/` directory:
- `TrackWeight.app` - Signed and notarized app
- `TrackWeight.zip` - ZIP submitted for notarization  
- `TrackWeight.dmg` - DMG installer for distribution

## Troubleshooting

### Common Issues

#### "No signing certificate found"
- Install Developer ID Application certificate in Keychain
- Make sure certificate is valid and not expired

#### "Notarization failed"
- Check Apple ID and app-specific password are correct
- Verify your Developer Program membership is active
- Check notarization logs: `xcrun notarytool log <submission-id>`

#### "App can't be opened because Apple cannot check it"
- Notarization may have failed
- Run: `spctl --assess --verbose /path/to/TrackWeight.app`
- Check if notarization ticket is stapled

#### "Gatekeeper assessment failed"
- App may not be properly signed
- Verify with: `codesign --verify --deep --strict TrackWeight.app`

### Debug Commands

```bash
# Check code signing
codesign -dv --verbose=4 TrackWeight.app

# Check notarization status
xcrun stapler validate TrackWeight.app

# Test Gatekeeper
spctl --assess --verbose TrackWeight.app

# List available signing identities
security find-identity -v -p codesigning
```

## Distribution

### Upload to GitHub Releases
1. Create a new release on GitHub
2. Upload the `TrackWeight.dmg` file
3. Users can download and install

### Update README
Add installation instructions:
```markdown
### Option 1: Download DMG (Recommended)
1. Download the latest `TrackWeight.dmg` from [Releases](https://github.com/krishkrosh/TrackWeight/releases)
2. Open the DMG and drag TrackWeight to Applications
3. Launch from Applications folder
```

## Security Notes

- The app is distributed **outside the Mac App Store**
- Uses **Developer ID** signing (not App Store signing)
- **Sandbox is disabled** (required for trackpad access)
- App is **notarized** by Apple for security
- Users won't see security warnings when launching

## Automation

You can integrate this script into:
- **GitHub Actions** for automatic releases
- **Local scripts** for regular builds
- **CI/CD pipelines** for team development

The script is designed to be idempotent and can be run multiple times safely.