# GitHub Actions Workflows

This directory contains GitHub Actions workflows for the TrackWeight project.

## build-and-sign-dmg.yml

This workflow builds, signs (if certificates are provided), and packages the TrackWeight macOS application into a DMG file.

### Features

- **Automated Building**: Builds the Xcode project using the latest stable Xcode
- **Code Signing**: Supports optional code signing with certificates
- **DMG Creation**: Creates a professional DMG with proper layout and attribution
- **Attribution**: Includes proper credits to the original repository (https://github.com/KrishKrosh/TrackWeight)
- **Release Integration**: Can create GitHub releases with the built DMG
- **Artifact Upload**: Uploads DMG as a GitHub Actions artifact

### Triggers

The workflow runs on:
- Git tags starting with 'v' (e.g., v1.0.0)
- Published releases
- Manual workflow dispatch

### Setup Instructions

#### Required Secrets (for signed builds)

To enable code signing, add these secrets to your GitHub repository:

1. **BUILD_CERTIFICATE_BASE64**: Base64-encoded Developer ID Application certificate (.p12 file)
   ```bash
   base64 -i YourCertificate.p12 | pbcopy
   ```

2. **P12_PASSWORD**: Password for the .p12 certificate file

3. **BUILD_PROVISION_PROFILE_BASE64**: Base64-encoded provisioning profile (optional for Developer ID)
   ```bash
   base64 -i YourProvisioningProfile.mobileprovision | pbcopy
   ```

#### Setting up Certificates

1. Export your Developer ID Application certificate from Keychain Access as a .p12 file
2. Convert to base64 and add as `BUILD_CERTIFICATE_BASE64` secret
3. Add the certificate password as `P12_PASSWORD` secret

#### Unsigned Builds

If you don't have code signing certificates, the workflow will automatically create an unsigned development build. These builds can still be used but may require users to manually allow them in System Preferences.

## build-unsigned-dmg.yml

This workflow specifically builds unsigned development versions of the TrackWeight app without requiring any certificates.

### Features

- **No Certificate Requirements**: Builds completely without code signing
- **Development Build**: Creates unsigned development builds that work on any Mac
- **Same DMG Features**: Includes all the same DMG features as the signed version
- **Clear User Instructions**: Includes instructions for running unsigned apps
- **Attribution**: Maintains proper credits to the original repository

### Triggers

The workflow runs on:
- Pushes to main branches and the current working branch
- Manual workflow dispatch

### Benefits

- **Easy Testing**: Perfect for testing builds without setting up certificates
- **No Configuration**: Works immediately without any secrets or setup
- **User-Friendly**: Includes clear instructions for users on how to run unsigned apps

## Choosing the Right Workflow

### Use `build-and-sign-dmg.yml` when:
- You have Apple Developer certificates
- You want to distribute signed, trusted builds
- You're creating official releases

### Use `build-unsigned-dmg.yml` when:
- You don't have certificates
- You want to test builds quickly
- You're developing or experimenting
- You need a simple build process

If no signing certificates are provided, the workflow will create an unsigned development build that can still be distributed and run locally (users may need to allow it in System Preferences > Security & Privacy).

### Usage

#### Manual Trigger
1. Go to Actions tab in your GitHub repository
2. Select "Build and Sign DMG" workflow
3. Click "Run workflow"
4. Optionally check "Create a GitHub release" to create a release

#### Automatic Trigger
1. Create a git tag: `git tag v1.0.0`
2. Push the tag: `git push origin v1.0.0`
3. The workflow will automatically build and create a release

### Output

The workflow produces:
- **DMG file**: TrackWeight-{version}.dmg containing the app and attribution
- **GitHub Release**: (if triggered by tag or manual release creation)
- **Artifacts**: DMG file uploaded as GitHub Actions artifact

### Attribution

This workflow ensures proper attribution to the original TrackWeight repository:
- README.txt file included in DMG with credits
- Release notes include attribution
- Links to original repository: https://github.com/KrishKrosh/TrackWeight

## update-homebrew.yml

This workflow automatically updates the Homebrew cask when a new release is published.

### Features
- Updates version in Homebrew tap repository
- Automatically triggered on release publication
- Can be manually triggered with version input

For more information about the original TrackWeight project, visit: https://github.com/KrishKrosh/TrackWeight