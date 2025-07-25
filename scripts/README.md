# Scripts

This directory contains helper scripts for the TrackWeight project.

## setup-signing.sh

A helper script to set up code signing certificates for automated DMG builds.

### Usage

```bash
./scripts/setup-signing.sh
```

### What it does

1. **Guides you through certificate export**: Provides step-by-step instructions to export your Developer ID Application certificate from Keychain Access
2. **Encodes certificates**: Converts your .p12 certificate file to base64 format required for GitHub Secrets
3. **Generates secret values**: Provides the exact values you need to add as GitHub repository secrets
4. **Optional provisioning profile**: Handles provisioning profile encoding if needed

### Prerequisites

- macOS (required for Keychain Access and signing tools)
- Valid Apple Developer ID Application certificate
- Access to GitHub repository settings to add secrets

### Output

The script will generate the values for these GitHub repository secrets:
- `BUILD_CERTIFICATE_BASE64`: Base64-encoded .p12 certificate
- `P12_PASSWORD`: Certificate password
- `BUILD_PROVISION_PROFILE_BASE64`: Base64-encoded provisioning profile (optional)

### Adding Secrets to GitHub

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Add each secret with the name and value provided by the script

### Attribution

This script is part of the enhanced TrackWeight fork that adds automated build pipelines.

**Original TrackWeight project**: https://github.com/KrishKrosh/TrackWeight  
**Created by**: Krish Shah (@KrishKrosh)