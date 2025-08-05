# TrackWeight

[English](#english-version)

**MacBookのトラックパッドを、精密なデジタルスケールに変える**

[TrackWeight](https://x.com/KrishRShah/status/1947186835811193330)は、モダンなMacBookのトラックパッドに内蔵されている感圧タッチセンサーを活用し、トラックパッドを正確なスケールに変えるmacOSアプリケーションです。

https://github.com/user-attachments/assets/7eaf9e0b-3dec-4829-b868-f54a8fd53a84

### 使用方法

1. スケールを開きます。
2. トラックパッドに指を置きます。
3. 指を触れたまま、測定したい物体をトラックパッドに乗せます。
4. 指の接触を保ちつつ、できるだけトラックパッドに圧力をかけないようにしてください。これが物体の重さです。

## 仕組み

TrackWeightは、[中村拓人](https://github.com/Kyome22)氏による[Open Multi-Touch Supportライブラリ](https://github.com/krishkrosh/OpenMultitouchSupport)のカスタムフォークを利用して、macOS上のすべてのマウスおよびトラックパッドイベントへのプライベートアクセスを取得します。このライブラリは、通常のアプリケーションではアクセスできない圧力測定値を含む詳細なタッチデータを提供します。

重要なのは、トラックパッドの圧力イベントが、トラックパッド表面で静電容量が検出されたときにのみ生成されるという点です。つまり、指（または他の導電性物体）がトラックパッドに接触している必要があります。この条件が満たされると、トラックパッドの感圧タッチセンサーが正確な圧力測定値を提供し、それを校正して重量測定値に変換することができます。

## 要件

- **macOS 13.0+** (Ventura以降)
- **感圧タッチトラックパッドを搭載したMacBook** (2015年以降のMacBook Pro, 2016年以降のMacBook)
- **App Sandboxの無効化** (低レベルのトラックパッドアクセスに必要)
- **Xcode 16.0+** および **Swift 6.0+** (開発用)

## インストール

### オプション1: DMGをダウンロード (推奨)

1. [リリースページ](https://github.com/krishkrosh/TrackWeight/releases)にアクセスします。
2. 最新のTrackWeight DMGファイルをダウンロードします。
3. DMGを開き、TrackWeight.appをアプリケーションフォルダにドラッグします。
4. アプリケーションを実行します（未署名のビルドの場合、システム環境設定 > セキュリティとプライバシーで許可が必要な場合があります）。

### オプション2: Homebrew
```bash
brew install --cask krishkrosh/apps/trackweight --force
```

### オプション3: ソースからビルド

1. このリポジトリをクローンします。
2. Xcodeで`TrackWeight.xcodeproj`を開きます。
3. プロジェクト設定でApp Sandboxを無効にします（トラックパッドアクセスに必要）。
4. アプリケーションをビルドして実行します。

ビルドパイプラインの設定に関する詳細は、[.github/workflows/README.md](.github/workflows/README.md)を参照してください。

## 開発

### Webサイト開発

このプロジェクトには、`docs/pages`にあるドキュメントサイトが含まれています。サイトをローカルで開発・プレビューするには、以下の手順に従ってください。

1.  **依存関係のインストール**:
    ```bash
    npm install
    ```

2.  **開発サーバーの起動**:
    ```bash
    npm start
    ```
    これにより、`http://localhost:8080`でライブサーバーが起動し、ファイルの変更が自動的にブラウザに反映されます。

### キャリブレーションプロセス

重量の計算は、以下の方法で検証されています：
1. MacBookのトラックパッドを、従来のデジタルスケールの上に直接置きます。
2. トラックパッドに指を触れたまま、様々な既知の重りを乗せます。
3. 圧力測定値を基準スケールの測定値と比較し、キャリブレーションします。
4. 異なる重量範囲で一貫した精度を確保します。

結果として、MultitouchSupportから得られるデータはすでにグラム単位であることが判明しました！

## 制限事項

- **指の接触が必要**: トラックパッドは静電容量（指の接触）を検出したときにのみ圧力測定値を提供するため、接触を維持せずに直接物体の重量を測定することはできません。
- **表面接触**: 測定する物体は、必要な指の接触を妨げないように配置する必要があります。
- **金属製の物体**: 金属製の物体は指の接触として検出される可能性があるため、正確な測定値を得るには、物体とトラックパッドの間に紙や布などを挟む必要がある場合があります。

## 技術詳細

このアプリケーションは、以下の技術を使用して構築されています：
- **SwiftUI**: ユーザーインターフェース
- **Combine**: リアクティブなデータフロー
- **Open Multi-Touch Supportライブラリ**: 低レベルのトラックパッドアクセス

### Open Multi-Touch Supportライブラリ

このプロジェクトは、**中村拓人** ([@Kyome22](https://github.com/Kyome22))氏と[Open Multi-Touch Supportライブラリ](https://github.com/krishkrosh/OpenMultitouchSupport)の素晴らしい成果に大きく依存しています。このライブラリは以下を提供します：

- macOSトラックパッドのグローバルなマルチタッチイベントへのアクセス
- 位置、圧力、角度、密度を含む詳細なタッチデータ
- タッチイベントストリームに対するスレッドセーフなasync/awaitのサポート
- タッチ状態の追跡と包括的なセンサーデータ

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 免責事項

このアプリケーションは、実験および教育目的のものです。精度の確保には努めていますが、TrackWeightは、精度が不可欠な重要な測定や商用アプリケーションには使用しないでください。重要な用途の場合は、必ず校正されたスケールで測定値を確認してください。

---

# English Version

**Turn your MacBook's trackpad into a precise digital weighing scale**

[TrackWeight](
https://x.com/KrishRShah/status/1947186835811193330) is a macOS application that transforms your MacBook's trackpad into an accurate weighing scale by leveraging the Force Touch pressure sensors built into modern MacBook trackpads.

https://github.com/user-attachments/assets/7eaf9e0b-3dec-4829-b868-f54a8fd53a84

To use it yourself:

1. Open the scale
2. Rest your finger on the trackpad
3. While maintaining finger contact, put your object on the trackpad
4. Try to put as little pressure on the trackpad while still maintaining contact. This is the weight of your object

## How It Works

TrackWeight utilizes a custom fork of the [Open Multi-Touch Support library](https://github.com/krishkrosh/OpenMultitouchSupport) by [Takuto Nakamura](https://github.com/Kyome22) to gain private access to all mouse and trackpad events on macOS. This library provides detailed touch data including pressure readings that are normally inaccessible to standard applications.

The key insight is that trackpad pressure events are only generated when there's capacitance detected on the trackpad surface - meaning your finger (or another conductive object) must be in contact with the trackpad. When this condition is met, the trackpad's Force Touch sensors provide precise pressure readings that can be calibrated and converted into weight measurements.

## Requirements

- **macOS 13.0+** (Ventura or later)
- **MacBook with Force Touch trackpad** (2015 or newer MacBook Pro, 2016 or newer MacBook)
- **App Sandbox disabled** (required for low-level trackpad access)
- **Xcode 16.0+** and **Swift 6.0+** (for development)

## Installation

### Option 1: Download DMG (Recommended)

1. Go to the [Releases](https://github.com/krishkrosh/TrackWeight/releases) page
2. Download the latest TrackWeight DMG file
3. Open the DMG and drag TrackWeight.app to your Applications folder
4. Run the application (you may need to allow it in System Preferences > Security & Privacy for unsigned builds)

### Option 2: Homebrew
```bash
brew install --cask krishkrosh/apps/trackweight --force
```
 
### Option 3: Build from Source

1. Clone this repository
2. Open `TrackWeight.xcodeproj` in Xcode
3. Disable App Sandbox in the project settings (required for trackpad access)
4. Build and run the application

For more information about setting up the build pipeline, see [.github/workflows/README.md](.github/workflows/README.md).

## Development

### Website Development

This project includes a documentation site located in `docs/pages`. To develop and preview the site locally, follow these steps:

1.  **Install Dependencies**:
    ```bash
    npm install
    ```

2.  **Start the Development Server**:
    ```bash
    npm start
    ```
    This will start a live server at `http://localhost:8080` and automatically reload the browser when files are changed.

### Calibration Process

The weight calculations have been validated by:
1. Placing the MacBook trackpad directly on top of a conventional digital scale
2. Applying various known weights while maintaining finger contact with the trackpad
3. Comparing and calibrating the pressure readings against the reference scale measurements
4. Ensuring consistent accuracy across different weight ranges

It turns out that the data we get from MultitouchSupport is already in grams!

## Limitations

- **Finger contact required**: The trackpad only provides pressure readings when it detects capacitance (finger touch), so you cannot weigh objects directly without maintaining contact
- **Surface contact**: Objects being weighed must be placed in a way that doesn't interfere with the required finger contact
- **Metal objects**: Metal objects may be detected as a finger touch, so you may need to place a piece of paper or a cloth between the object and the trackpad to get an accurate reading

## Technical Details

The application is built using:
- **SwiftUI** for the user interface
- **Combine** for reactive data flow
- **Open Multi-Touch Support library** for low-level trackpad access

### Open Multi-Touch Support Library

This project relies heavily on the excellent work by **Takuto Nakamura** ([@Kyome22](https://github.com/Kyome22)) and the [Open Multi-Touch Support library](https://github.com/krishkrosh/OpenMultitouchSupport). The library provides:

- Access to global multitouch events on macOS trackpads
- Detailed touch data including position, pressure, angle, and density
- Thread-safe async/await support for touch event streams
- Touch state tracking and comprehensive sensor data

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This application is for experimental and educational purposes. While efforts have been made to ensure accuracy, TrackWeight should not be used for critical measurements or commercial applications where precision is essential. Always verify measurements with a calibrated scale for important use cases.