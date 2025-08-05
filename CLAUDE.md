# TrackWeight 専用開発ガイドライン

## ⚖️ プロジェクト概要
**TrackWeight - MacBookトラックパッドを精密デジタル秤に変換**
- **コンセプト**: Force Touchセンサーを活用した革新的な重量測定アプリ
- **技術スタック**: Swift 6.0+, SwiftUI, Combine, OpenMultitouchSupport
- **対象OS**: macOS 13.0+ (Force Touch対応MacBook必須)
- **品質目標**: 高精度測定、安定性、使いやすさ

## 🤖 専用サブエージェント

### 開発用エージェント
- **general-purpose**: Swift/SwiftUI開発、アーキテクチャ設計、デバッグ支援
- **qa-tester**: 品質保証、ビルド検証、パフォーマンステスト

### 管理用エージェント  
- **task-manager**: 開発タスク管理、進捗トラッキング
- **git-manager**: Gitフロー管理、ブランチ戦略、リリース準備

## ⚡ 専用カスタムコマンド

### 開発系コマンド
- `/tw-develop [機能]` - Swift機能開発・UI実装
- `/tw-calibrate [測定値]` - 重量測定キャリブレーション調整
- `/tw-debug [問題]` - トラックパッド関連問題のデバッグ
- `/tw-ui [コンポーネント]` - SwiftUIコンポーネント改善

### ビルド・テスト系コマンド
- `/tw-build` - Xcodeプロジェクトビルド実行
- `/tw-test [項目]` - 機能テスト・検証実行
- `/tw-sign` - コード署名・証明書設定
- `/tw-dmg` - DMGパッケージ作成

### 管理系コマンド
- `/tw-task [内容]` - 開発タスク管理・進捗確認
- `/tw-release [バージョン]` - リリース準備・タグ作成
- `/tw-hotfix [問題]` - 緊急バグ修正

## 🎨 デザインガイドライン

### コンセプト
- **精密性**: 正確で信頼できる測定
- **革新性**: 従来にない新しい測定方法
- **シンプルさ**: 直感的で使いやすいインターフェース
- **技術的**: 先進技術を活用した実用的ツール

### カラーパレット
```swift
// SwiftUI Color Scheme
struct TrackWeightColors {
    static let primary = Color(red: 0.2, green: 0.6, blue: 1.0)      // ブルー系
    static let secondary = Color(red: 0.9, green: 0.9, blue: 0.9)    // ライトグレー
    static let accent = Color(red: 0.0, green: 0.8, blue: 0.4)       // グリーン系
    static let background = Color(red: 0.98, green: 0.98, blue: 1.0) // オフホワイト
    static let text = Color(red: 0.2, green: 0.2, blue: 0.2)         // ダークグレー
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.0)      // オレンジ
}
```

### デザイン原則
- ○「精密」「正確」「革新的」「効率的」「直感的」
- ×「複雑」「曖昧」「古典的」
- モダンで洗練されたUI/UX
- 数値の視認性を重視したタイポグラフィ

## 🎯 開発の進め方

Swiftプロジェクトの特性を活かした効率的な開発を推進します。Xcodeとの連携、OpenMultitouchSupportライブラリとの統合に注意して開発を進めます。

## 📋 プロジェクト構造
- **TrackWeight.xcodeproj**: メインXcodeプロジェクト
- **TrackWeight/**: Swiftソースコード
- **scripts/**: ビルド・署名関連スクリプト
- **docs/**: プロジェクト関連ドキュメント
- **.github/workflows/**: CI/CDパイプライン

## 🛠️ 開発フロー（Xcode対応）

### 1. 開発環境準備・タスク確認
```bash
/tw-task 開発タスク確認
/tw-develop [実装したい機能]
```

### 2. Swift開発・ビルド
```bash
/tw-build      # Xcodeプロジェクトビルド
/tw-test UI測定精度  # 機能テスト実行
```

### 3. 品質チェック・リリース準備
```bash
/tw-sign       # コード署名確認
/tw-dmg        # DMGパッケージ作成
/tw-release v1.x.x  # リリース準備
```

## 📋 必須品質基準

### 測定精度・安定性
- 重量測定精度: ±1g以内
- 圧力センサー応答時間: 100ms以下
- 連続測定の安定性確保
- キャリブレーション機能の正確性

### macOSアプリ品質
- macOS 13.0+完全対応
- Force Touch対応MacBook必須要件
- App Sandboxの適切な無効化
- メモリリーク・クラッシュ回避

### コード品質
- Swift 6.0準拠
- SwiftUIベストプラクティス
- Combineの適切な使用
- 適切なエラーハンドリング

## 🔄 Git運用（Swift対応）

### ブランチ戦略
```bash
git checkout -b feature/[機能名]     # 新機能開発
git checkout -b fix/[修正内容]       # バグ修正
git checkout -b calibration/[調整]   # 測定調整
git checkout -b release/[バージョン]  # リリース準備
```

### コミットメッセージ規約
- `feat:` 新機能追加
- `fix:` バグ修正
- `ui:` UI/UX改善
- `calibrate:` 測定精度調整
- `perf:` パフォーマンス最適化
- `build:` ビルド・署名関連

### 開発ワークフロー
- 開発前: Xcodeプロジェクト状態確認
- コミット前: ビルド成功確認
- リリース前: DMG作成・署名検証

## 🎯 開発優先順位

### Phase 1: コア機能強化
1. 測定精度の向上・キャリブレーション改善
2. UI/UXの最適化・ユーザビリティ向上
3. エラーハンドリング・安定性確保
4. パフォーマンス最適化

### Phase 2: 機能拡張
1. 測定データの保存・履歴機能
2. 単位変換・表示オプション
3. 設定画面・カスタマイズ機能
4. より高度なキャリブレーション

### Phase 3: リリース・配布
1. コード署名・公証対応
2. DMG配布・Homebrew対応
3. ドキュメント整備
4. 公式リリース

## 📝 重要な制約・注意事項

### macOS技術制約
- Force Touch対応MacBook必須（2015年以降）
- App Sandbox無効化必要（低レベルアクセス）
- macOS 13.0+対応必須
- Swift 6.0+、Xcode 16.0+必須

### OpenMultitouchSupport依存性
- Takuto Nakamura氏のライブラリ使用
- 低レベルトラックパッドアクセス
- 指接触必須（容量性検出）
- プライベートAPI使用のリスク

### 測定上の制約
- 指接触維持が必須条件
- 金属物体は誤検出の可能性
- 表面接触による測定誤差
- 実験・教育目的での使用推奨

---

## 🚀 開発開始手順

1. **現状確認**: `/tw-task プロジェクト状況確認`
2. **機能開発**: `/tw-develop [実装したい内容]`
3. **ビルド確認**: `/tw-build`
4. **進捗更新**: 開発タスクの自動更新

**コンセプトを常に意識**: Force Touchの革新的活用で「精密で直感的な重量測定」を実現する技術実験プロジェクト
