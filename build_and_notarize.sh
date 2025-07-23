#!/bin/bash

# TrackWeight Build, Sign, and Notarize Script
# This script builds, signs, notarizes, and packages TrackWeight for distribution

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - UPDATE THESE VALUES
APP_NAME="TrackWeight"
BUNDLE_ID="com.krishkrosh.trackweight"
DEVELOPER_ID="9ZRLG6277G"  # Your development team ID
SIGNING_IDENTITY="Developer ID Application"  # For distribution outside App Store
INSTALLER_IDENTITY="Developer ID Installer"  # For installer packages

# Apple Developer credentials for notarization
APPLE_ID=""  # Your Apple ID email - SET THIS
APP_PASSWORD=""  # App-specific password - SET THIS
TEAM_ID="9ZRLG6277G"  # Your team ID

# Build configuration
CONFIGURATION="Release"
ARCHIVE_PATH="./build/${APP_NAME}.xcarchive"
APP_PATH="./build/${APP_NAME}.app"
DMG_PATH="./build/${APP_NAME}.dmg"
ZIP_PATH="./build/${APP_NAME}.zip"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script must be run on macOS"
        exit 1
    fi
    
    # Check if Xcode is installed
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is not installed or xcodebuild is not in PATH"
        exit 1
    fi
    
    # Check if notarytool is available (Xcode 13+)
    if ! xcrun notarytool --help &> /dev/null; then
        print_error "notarytool is not available. Please update to Xcode 13 or later"
        exit 1
    fi
    
    # Check for Apple ID and App Password
    if [[ -z "$APPLE_ID" || -z "$APP_PASSWORD" ]]; then
        print_error "Please set APPLE_ID and APP_PASSWORD in the script"
        print_error "APPLE_ID: Your Apple Developer account email"
        print_error "APP_PASSWORD: Generate at https://appleid.apple.com/account/manage (App-Specific Passwords)"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to clean previous builds
clean_build() {
    print_status "Cleaning previous builds..."
    rm -rf build/
    mkdir -p build/
    print_success "Build directory cleaned"
}

# Function to build the app
build_app() {
    print_status "Building ${APP_NAME}..."
    
    # Create entitlements for distribution (disable sandbox)
    cat > build/TrackWeight-Distribution.entitlements << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <false/>
    <key>com.apple.security.cs.allow-jit</key>
    <true/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
</dict>
</plist>
EOF

    # Build and archive
    xcodebuild archive \
        -project "${APP_NAME}.xcodeproj" \
        -scheme "${APP_NAME}" \
        -configuration "${CONFIGURATION}" \
        -archivePath "${ARCHIVE_PATH}" \
        -derivedDataPath build/DerivedData \
        CODE_SIGN_IDENTITY="${SIGNING_IDENTITY}: ${DEVELOPER_ID}" \
        DEVELOPMENT_TEAM="${DEVELOPER_ID}" \
        CODE_SIGNING_REQUIRED=YES \
        CODE_SIGNING_ALLOWED=YES \
        OTHER_CODE_SIGN_FLAGS="--entitlements=build/TrackWeight-Distribution.entitlements" \
        | tee build/build.log
    
    if [ $? -eq 0 ]; then
        print_success "Build completed successfully"
    else
        print_error "Build failed. Check build/build.log for details"
        exit 1
    fi
}

# Function to export the app from archive
export_app() {
    print_status "Exporting app from archive..."
    
    # Create export options plist
    cat > build/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>${DEVELOPER_ID}</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
</dict>
</plist>
EOF

    xcodebuild -exportArchive \
        -archivePath "${ARCHIVE_PATH}" \
        -exportPath build/ \
        -exportOptionsPlist build/ExportOptions.plist
    
    # Move the exported app to expected location
    if [ -d "build/${APP_NAME}.app" ]; then
        print_success "App exported successfully"
    else
        print_error "App export failed"
        exit 1
    fi
}

# Function to verify code signing
verify_signing() {
    print_status "Verifying code signing..."
    
    codesign --verify --deep --strict --verbose=2 "${APP_PATH}"
    if [ $? -eq 0 ]; then
        print_success "Code signing verification passed"
    else
        print_error "Code signing verification failed"
        exit 1
    fi
    
    # Display signing information
    print_status "Signing information:"
    codesign -dv --verbose=4 "${APP_PATH}" 2>&1 | grep -E "(Identifier|Authority|TeamIdentifier|Executable)"
}

# Function to create ZIP for notarization
create_zip() {
    print_status "Creating ZIP archive for notarization..."
    
    cd build/
    zip -r "${APP_NAME}.zip" "${APP_NAME}.app"
    cd ..
    
    print_success "ZIP archive created: ${ZIP_PATH}"
}

# Function to submit for notarization
submit_for_notarization() {
    print_status "Submitting app for notarization..."
    
    # Submit for notarization
    SUBMISSION_ID=$(xcrun notarytool submit "${ZIP_PATH}" \
        --apple-id "${APPLE_ID}" \
        --password "${APP_PASSWORD}" \
        --team-id "${TEAM_ID}" \
        --wait \
        --output-format json | jq -r '.id')
    
    if [ $? -eq 0 ]; then
        print_success "Notarization submitted successfully"
        print_status "Submission ID: ${SUBMISSION_ID}"
    else
        print_error "Notarization submission failed"
        exit 1
    fi
    
    # Check notarization status
    print_status "Checking notarization status..."
    xcrun notarytool info "${SUBMISSION_ID}" \
        --apple-id "${APPLE_ID}" \
        --password "${APP_PASSWORD}" \
        --team-id "${TEAM_ID}"
}

# Function to staple the notarization
staple_notarization() {
    print_status "Stapling notarization to app..."
    
    xcrun stapler staple "${APP_PATH}"
    if [ $? -eq 0 ]; then
        print_success "Notarization stapled successfully"
    else
        print_error "Stapling failed"
        exit 1
    fi
    
    # Verify stapling
    print_status "Verifying stapling..."
    xcrun stapler validate "${APP_PATH}"
}

# Function to install create-dmg if needed
install_create_dmg() {
    if ! command -v create-dmg &> /dev/null; then
        print_status "Installing create-dmg..."
        if command -v brew &> /dev/null; then
            brew install create-dmg
        else
            print_error "create-dmg not found and Homebrew not available"
            print_error "Install create-dmg with: brew install create-dmg"
            print_error "Or install Homebrew from: https://brew.sh"
            exit 1
        fi
    fi
}

# Function to create DMG
create_dmg() {
    print_status "Creating professional DMG installer..."
    
    install_create_dmg
    
    # Remove existing DMG if it exists
    rm -f "${DMG_PATH}"
    
    # Create DMG with create-dmg (much better than hdiutil)
    create-dmg \
        --volname "${APP_NAME}" \
        --volicon "TrackWeight/Assets.xcassets/AppIcon.appiconset/512.png" \
        --window-pos 200 120 \
        --window-size 800 400 \
        --icon-size 100 \
        --icon "${APP_NAME}.app" 200 190 \
        --hide-extension "${APP_NAME}.app" \
        --app-drop-link 600 185 \
        --hdiutil-quiet \
        --background-color "#f0f3f7" \
        "${DMG_PATH}" \
        "${APP_PATH}"
    
    if [ -f "${DMG_PATH}" ]; then
        print_success "Professional DMG created: ${DMG_PATH}"
        print_status "DMG features:"
        print_status "  • Custom window size and positioning"
        print_status "  • App icon and Applications folder shortcut"
        print_status "  • Clean background and proper layout"
        print_status "  • Hidden file extensions for cleaner look"
    else
        print_error "DMG creation failed"
        exit 1
    fi
}

# Function to run final verification
final_verification() {
    print_status "Running final verification..."
    
    # Verify the app can run
    print_status "Testing app launch..."
    timeout 5s "${APP_PATH}/Contents/MacOS/${APP_NAME}" --version 2>/dev/null || true
    
    # Check Gatekeeper
    print_status "Checking Gatekeeper assessment..."
    spctl --assess --verbose "${APP_PATH}"
    
    if [ $? -eq 0 ]; then
        print_success "Gatekeeper assessment passed"
    else
        print_warning "Gatekeeper assessment failed - users may see security warnings"
    fi
}

# Function to display summary
display_summary() {
    print_success "🎉 Build and notarization complete!"
    echo ""
    echo "📦 Distribution files created:"
    echo "   • App: ${APP_PATH}"
    echo "   • ZIP: ${ZIP_PATH}"
    echo "   • DMG: ${DMG_PATH}"
    echo ""
    echo "📋 Next steps:"
    echo "   • Test the app on a different Mac"
    echo "   • Upload DMG to your website/GitHub releases"
    echo "   • Users can download and install the DMG"
    echo ""
    echo "🔒 Security status:"
    echo "   • Code signed with Developer ID"
    echo "   • Notarized by Apple"
    echo "   • Ready for distribution outside the App Store"
}

# Main execution
main() {
    echo "🚀 TrackWeight Build and Notarization Script"
    echo "============================================"
    
    check_prerequisites
    clean_build
    build_app
    export_app
    verify_signing
    create_zip
    submit_for_notarization
    staple_notarization
    create_dmg
    final_verification
    display_summary
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi