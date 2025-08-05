# /ghj-responsive

GroupHomeJuju のレスポンシブ対応を実行します。

## 実行内容
1. **frontend-developer エージェント起動**: モバイルファースト実装
2. **ブレイクポイント確認**: 320px/768px/1024px での表示
3. **レイアウト調整**: Grid/Flexbox による柔軟なレイアウト
4. **タッチUI最適化**: 44px以上のタッチターゲット確保
5. **画像最適化**: レスポンシブイメージの実装
6. **qa-tester で確認**: 各デバイスでの動作検証

**引数**: $ARGUMENTS (対応したいページ・コンポーネント)

**使用例**:
- `/ghj-responsive ナビゲーションメニュー`
- `/ghj-responsive 料金表`
- `/ghj-responsive 全ページ`

Mobile First アプローチで実装します。
