# 📋 TrackWeight Landing Page - ヴァイブコーディング用 TODO

> **🎯 Goal**: TrackWeightの魅力を最大限に伝える、技術的革新性と日常の楽しさのバランスが取れたランディングページ作成

## 🚀 Phase 1: 基盤構築 (Foundation) - 2-3 hours

### 1.1 プロジェクト構造セットアップ (20分)
- [ ] `docs/landing/` ディレクトリ作成
- [ ] `index.html` - メインHTML構造
- [ ] `styles/` フォルダと基本CSS
  - [ ] `main.css` - ベースとレイアウト
  - [ ] `colors.css` - Playful Techカラーパレット定義
  - [ ] `animations.css` - トラックパッドアニメーション等
- [ ] `scripts/` フォルダとJS
  - [ ] `main.js` - インタラクション制御
  - [ ] `animations.js` - Hero sectionアニメーション
- [ ] `assets/` フォルダ
  - [ ] `images/` - アイコン・デモ画像用
  - [ ] `icons/` - SVGアイコン集

### 1.2 HTML骨格作成 (30分)
```html
<!-- セクション構造定義 -->
<header>Navigation</header>
<main>
  <section id="hero">Hero with trackpad animation</section>
  <section id="features">3 Use Cases</section>
  <section id="how-it-works">4 Steps visualization</section>
  <section id="faq">Accordion FAQ</section>
  <section id="download">CTA Section</section>
</main>
<footer>Footer</footer>
```

### 1.3 CSS基盤とカラーパレット (40分)
- [ ] CSS Custom Properties定義 (Playful Tech colors)
- [ ] レスポンシブグリッドシステム
- [ ] タイポグラフィー階層 (h1-h6, body text)
- [ ] ボタンコンポーネント (primary, secondary, accent)

### 1.4 基本レイアウト検証 (30分)
- [ ] モバイル/デスクトップ表示確認
- [ ] セクション間の適切なスペーシング
- [ ] 基本ナビゲーション動作確認

---

## 🎭 Phase 2: Hero Section (Wow Factor) - 1.5-2 hours

### 2.1 Hero Content Structure (30分)
```html
<section id="hero">
  <div class="hero-content">
    <h1>Turn Your MacBook Trackpad Into a Precision Digital Scale</h1>
    <p class="hero-subtitle">Simply place your finger and measure. Revolutionary Force Touch technology meets everyday convenience.</p>
    <div class="hero-cta">
      <button class="btn-primary">Download Now</button>
      <button class="btn-secondary">See Demo</button>
    </div>
  </div>
  <div class="hero-visual">
    <div class="trackpad-animation"></div>
  </div>
</section>
```

### 2.2 トラックパッドアニメーション実装 (60分)
- [ ] CSS Keyframes: 指の接触シミュレーション
- [ ] 圧力感知の視覚化 (リング状のripple effect)
- [ ] 重量表示の数値カウントアップ
- [ ] Force Touchの光の反射効果
- [ ] ホバー時のインタラクティブ反応

### 2.3 Hero レスポンシブ調整 (20分)
- [ ] モバイル: 縦配置、アニメーション簡略化
- [ ] タブレット: バランス調整
- [ ] デスクトップ: 横並び最適化

---

## 🌟 Phase 3: Features Section (Use Cases) - 2 hours

### 3.1 3つのユースケースカード実装 (90分)

#### Card 1: Kitchen Scale (30分)
```html
<div class="feature-card kitchen">
  <div class="card-icon">🍳</div>
  <h3>Smart Kitchen Assistant</h3>
  <p>Measure spices, small ingredients, or portion sizes with gram precision. No more bulky kitchen scales!</p>
  <div class="card-demo">
    <!-- Small interaction demo -->
  </div>
</div>
```

#### Card 2: Delivery Companion (30分)
```html
<div class="feature-card delivery">
  <div class="card-icon">📦</div>
  <h3>Delivery Weight Check</h3>
  <p>Quick verification of small package weights before shipping. Perfect for online sellers and frequent shippers.</p>
  <div class="card-demo">
    <!-- Package visualization -->
  </div>
</div>
```

#### Card 3: Educational Tool (30分)
```html
<div class="feature-card education">
  <div class="card-icon">🔬</div>
  <h3>STEM Learning Lab</h3>
  <p>Hands-on physics experiments and precise measurements. Turn your laptop into a science laboratory instrument.</p>
  <div class="card-demo">
    <!-- Educational demo -->
  </div>
</div>
```

### 3.2 カードインタラクション (30分)
- [ ] Hover effects: カード浮上、色変化
- [ ] ステイジャードアニメーション (順次表示)
- [ ] アイコンの微細なアニメーション

---

## ⚙️ Phase 4: How It Works Section - 1.5 hours

### 4.1 4ステップビジュアライゼーション (60分)

#### Step 1: Open App (15分)
- [ ] アプリアイコンからウィンドウ展開アニメーション
- [ ] 「Click to launch」インタラクション

#### Step 2: Calibrate (15分)
- [ ] 校正プロセスの視覚化
- [ ] ゼロ値設定アニメーション

#### Step 3: Place Object (15分)
- [ ] オブジェクト配置シミュレーション
- [ ] 接触検知の光る効果

#### Step 4: Read Weight (15分)
- [ ] 数値表示のカウントアップ
- [ ] 測定完了の満足感演出

### 4.2 セクション全体レイアウト (30分)
- [ ] 横スクロール / 縦配置のレスポンシブ切り替え
- [ ] プログレスバー表示
- [ ] 「Try Interactive Demo」ボタン

---

## ❓ Phase 5: FAQ Section - 1 hour

### 5.1 アコーディオン実装 (40分)
```javascript
// FAQ structure with personality
const faqs = [
  {
    q: "Wait, my trackpad can actually weigh things? 🤯",
    a: "Yes! Your MacBook's Force Touch sensors are incredibly precise pressure detectors..."
  },
  {
    q: "How accurate is this wizardry?",
    a: "Within ±1 gram for objects under 50g. Perfect for spices, not your cat! 😸"
  },
  {
    q: "Will this void my MacBook warranty?",
    a: "Absolutely not! We only read sensor data, no hardware modifications needed."
  }
  // ... more questions
];
```

### 5.2 FAQ UX最適化 (20分)
- [ ] スムーズな開閉アニメーション
- [ ] 楽しい絵文字とトーン設定
- [ ] 検索機能（オプション）

---

## 💾 Phase 6: Download Section - 1 hour

### 6.1 CTA Section構築 (40分)
```html
<section id="download">
  <div class="download-hero">
    <h2>Ready to Transform Your Trackpad?</h2>
    <p>Choose your preferred installation method</p>
  </div>
  
  <div class="download-options">
    <div class="option homebrew">
      <h3>🍺 Homebrew (Recommended)</h3>
      <code>brew install --cask trackweight</code>
      <button class="copy-button">Copy Command</button>
    </div>
    
    <div class="option github">
      <h3>⬇️ Direct Download</h3>
      <p>Download .dmg from GitHub Releases</p>
      <button class="download-button">Download Latest</button>
    </div>
  </div>
</section>
```

### 6.2 ダウンロード機能実装 (20分)
- [ ] コピーボタン機能
- [ ] GitHub API連携で最新リリース取得
- [ ] 成功時のフィードバック演出

---

## 📱 Phase 7: レスポンシブ & 最適化 - 2 hours

### 7.1 レスポンシブ調整 (90分)
- [ ] **Mobile (320px-768px)**
  - [ ] ハンバーガーメニュー
  - [ ] 縦積みレイアウト
  - [ ] タッチ最適化
- [ ] **Tablet (768px-1024px)**
  - [ ] 2カラムレイアウト
  - [ ] アニメーション調整
- [ ] **Desktop (1024px+)**
  - [ ] フルレイアウト
  - [ ] パララックス効果（オプション）

### 7.2 パフォーマンス最適化 (30分)
- [ ] 画像圧縮・最適化
- [ ] CSS/JS最小化
- [ ] Lazy loading実装
- [ ] Core Web Vitals確認

---

## ♿ Phase 8: アクセシビリティ & 仕上げ - 1 hour

### 8.1 アクセシビリティ対応 (40分)
- [ ] セマンティックHTML確認
- [ ] ARIA labels追加
- [ ] キーボードナビゲーション
- [ ] カラーコントラスト確認（4.5:1以上）
- [ ] スクリーンリーダー対応

### 8.2 最終調整 (20分)
- [ ] 全セクション動作確認
- [ ] エラーハンドリング
- [ ] 読み込み速度測定
- [ ] クロスブラウザテスト

---

## 🎨 デザインスペック参考

### カラーパレット (Playful Tech)
```css
:root {
  --primary-blue: #007AFF;
  --primary-teal: #32D2C7;
  --accent-orange: #FF9500;
  --bg-primary: #FAFAFA;
  --text-primary: #1D1D1F;
  --gradient-hero: linear-gradient(135deg, #007AFF 0%, #32D2C7 100%);
}
```

### アニメーション原則
- **Hero**: 3-5秒ループ、自然な一時停止
- **Cards**: Intersection Observer + stagger (0.1s intervals)
- **Buttons**: 0.2s ease-out transitions
- **Scroll**: 少なくとも60fps維持

### コンテンツトーン
- **Hero**: 驚きと期待感
- **Features**: 具体的価値提案
- **How It Works**: わかりやすさ重視
- **FAQ**: 親しみやすく楽しく
- **Download**: 行動喚起、簡単さ強調

---

## 🎯 成功指標

### 技術的目標
- [ ] **Core Web Vitals**: Good (緑) スコア
- [ ] **Lighthouse**: 90+ Performance, 100 Accessibility
- [ ] **Mobile-friendly**: Google Test合格

### UX目標
- [ ] **First Impression**: 3秒以内に価値理解
- [ ] **Engagement**: Average 2+ minutes on page
- [ ] **Action**: Clear download path, <3 clicks

---

**🔥 Vibe Coding Tips:**
- 楽しく、エネルギッシュに！
- 各セクション完成時は小さなお祝いを
- 詰まったら他セクションに移って、後で戻る
- 80%で次に進む（完璧主義は禁物）
- ユーザーの驚きと喜びを常に意識して実装