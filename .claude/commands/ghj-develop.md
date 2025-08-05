# /ghj-develop

GroupHomeJuju プロジェクトの統合開発を実行します。

## 実行内容
1. **プロジェクト状況確認**: TODO.mdで現在のタスクを確認
2. **技術要件確認**: 静的サイト・GitHub Pages・アクセシビリティ対応
3. **エージェント選択**: 適切な専門エージェント（frontend-developer/content-designer等）を起動
4. **段階的実装**: HTML→CSS→JavaScript の順序で実装
5. **品質チェック**: qa-testerでアクセシビリティ・パフォーマンス確認
6. **ビルド実行**: `npm run build` でlint+format
7. **進捗更新**: TODO.mdの該当タスクを更新

**引数**: $ARGUMENTS (実装したい機能・ページの説明)

**使用例**: `/ghj-develop お問い合わせページのレスポンシブ対応`

コンセプト「おじいちゃんが建てたあったかいおうち」を大切に実装します。
