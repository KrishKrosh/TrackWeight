#!/bin/bash

# setup-signing.sh
# Helper script to set up code signing certificates for TrackWeight DMG builds
# 
# This script helps you prepare the necessary secrets for GitHub Actions
# to build signed DMG files.

set -e

echo "🔐 TrackWeight Code Signing Setup"
echo "=================================="
echo ""
echo "This script helps you set up code signing for automated DMG builds."
echo "You'll need a valid Apple Developer ID Application certificate."
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS to access Keychain and signing tools."
    exit 1
fi

# Function to encode file to base64
encode_file() {
    local file_path="$1"
    if [[ -f "$file_path" ]]; then
        base64 -i "$file_path"
    else
        echo "❌ File not found: $file_path"
        return 1
    fi
}

echo "Step 1: Export your Developer ID Application certificate"
echo "--------------------------------------------------------"
echo "1. Open Keychain Access"
echo "2. Find your 'Developer ID Application' certificate"
echo "3. Right-click and select 'Export'"
echo "4. Save as .p12 format with a password"
echo ""
read -p "Enter the path to your exported .p12 certificate: " cert_path

if [[ ! -f "$cert_path" ]]; then
    echo "❌ Certificate file not found: $cert_path"
    exit 1
fi

echo ""
read -s -p "Enter the password for your .p12 certificate: " cert_password
echo ""

echo ""
echo "Step 2: Encoding certificate for GitHub Secrets"
echo "----------------------------------------------"

# Encode the certificate
echo "Encoding certificate..."
cert_base64=$(encode_file "$cert_path")

if [[ -z "$cert_base64" ]]; then
    echo "❌ Failed to encode certificate"
    exit 1
fi

echo "✅ Certificate encoded successfully"

echo ""
echo "Step 3: GitHub Repository Secrets"
echo "--------------------------------"
echo "Add these secrets to your GitHub repository:"
echo "(Go to Settings > Secrets and variables > Actions)"
echo ""
echo "1. Secret name: BUILD_CERTIFICATE_BASE64"
echo "   Value: (copy the text below)"
echo ""
echo "$cert_base64"
echo ""
echo "2. Secret name: P12_PASSWORD"
echo "   Value: $cert_password"
echo ""

# Check for provisioning profile (optional for Developer ID)
echo "Step 4: Provisioning Profile (Optional)"
echo "--------------------------------------"
read -p "Do you have a provisioning profile to include? (y/n): " include_profile

if [[ "$include_profile" =~ ^[Yy]$ ]]; then
    read -p "Enter the path to your .mobileprovision file: " profile_path
    
    if [[ -f "$profile_path" ]]; then
        profile_base64=$(encode_file "$profile_path")
        echo ""
        echo "3. Secret name: BUILD_PROVISION_PROFILE_BASE64"
        echo "   Value: (copy the text below)"
        echo ""
        echo "$profile_base64"
    else
        echo "❌ Provisioning profile not found: $profile_path"
    fi
else
    echo "📝 Skipping provisioning profile (Developer ID usually doesn't need one)"
fi

echo ""
echo "🎉 Setup Complete!"
echo "================="
echo ""
echo "Next steps:"
echo "1. Add the secrets to your GitHub repository"
echo "2. Create a git tag to trigger the build: git tag v1.0.0 && git push origin v1.0.0"
echo "3. Or manually trigger the workflow from the Actions tab"
echo ""
echo "The workflow will:"
echo "- Build and sign your app with the provided certificate"
echo "- Create a professional DMG with attribution to the original repo"
echo "- Upload the DMG as a release artifact"
echo ""
echo "Original TrackWeight project: https://github.com/KrishKrosh/TrackWeight"