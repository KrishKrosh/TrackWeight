# /ghj-optimize

GroupHomeJuju のパフォーマンス最適化を実行します。

## 実行内容
1. **qa-tester エージェント起動**: Lighthouse スコア測定
2. **画像最適化**: WebP対応・遅延読み込み実装
3. **CSS/JS最小化**: ビルドプロセス最適化
4. **Core Web Vitals改善**: LCP/FID/CLS の向上
5. **GitHub Pages最適化**: 静的サイト向け調整
6. **キャッシュ戦略**: ブラウザキャッシュ活用

**引数**: $ARGUMENTS (最適化したい項目)

**使用例**:
- `/ghj-optimize 画像読み込み速度`
- `/ghj-optimize CSS ファイルサイズ`
- `/ghj-optimize Core Web Vitals`

Lighthouse 90以上を目標に最適化します。
