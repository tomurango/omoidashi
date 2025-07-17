# リメンモー (REMENMEMO) - 開発メモ

## プロジェクト概要
- **アプリ名**: リメンモー - 思い出すメモアプリ（REMENMEMO）
- **デバイス表示名**: リメンモー
- **コンセプト**: 「大切な考えを、いつでも思い出せる」
- **技術スタック**: Flutter + Riverpod + Hooks + ローカルJSON保存
- **対象**: 学習者、研究者、クリエイター

## 完了した機能

### 基本機能
- [x] メモの作成・編集・削除
- [x] タグ機能（カテゴリから変更）
- [x] お気に入り機能
- [x] 検索・フィルター機能
- [x] ランダム表示機能
- [x] ローカルJSON保存

### UI/UX
- [x] Material Design 3準拠
- [x] ホーム画面: Twitter風のシンプルなリスト表示
- [x] メモ詳細画面: コンテンツファーストデザイン
- [x] メモ作成画面: リアルタイム保存ボタン制御
- [x] レスポンシブデザイン

### 状態管理
- [x] Riverpod + Hooksによる状態管理
- [x] リアルタイムのお気に入り状態反映
- [x] 検索とフィルターの連携
- [x] 非同期データ処理

### リリース準備機能（2025-07-15追加）
- [x] 設定画面の実装
- [x] 利用規約画面の実装
- [x] プライバシーポリシー画面の実装
- [x] アプリアイコンの適用
- [x] アプリ表示名「オモイダシ」の設定
- [x] テーマカラー#1565C0の適用

## 主な技術的改善

### アーキテクチャ変更
- カテゴリベースからタグベースシステムへの移行
- LateInitializationError修正（File? _fileに変更）
- 重複保存ボタンの削除

### UI改善
- ホーム画面を複雑なCardからシンプルなListTileに変更
- メモ詳細画面でのリアルタイム更新対応
- Material Design 3準拠のツールバー実装

## 現在の状態
- 基本機能は完成
- リリース準備完了
- GitHub Pages公式サイト完成
- App Store/Google Play審査準備完了

## 今後の開発計画

### Phase 1: 基本リリース (1-2ヶ月)
- [ ] App Store/Google Play リリース
- [ ] ユーザー獲得・フィードバック収集
- [ ] 基本機能の安定化

### Phase 2: 広告導入 (1ヶ月)
- [ ] Google AdMob設定
- [ ] バナー広告実装
  - ホーム画面: メモリスト内に3-5個おきに配置
  - 詳細画面: 下部固定配置
- [ ] インタースティシャル広告実装
  - メモ作成完了後に表示
  - 5回操作ごとに1回表示
- [ ] 収益データ収集・最適化

### Phase 3: AI機能開発 (2-3ヶ月)
- [ ] OpenAI API統合
- [ ] セマンティック検索機能
- [ ] AI要約・分析機能
- [ ] AI質問応答機能
- [ ] タグ自動提案機能

### Phase 4: プレミアム展開 (1ヶ月)
- [ ] フリーミアムモデル実装
- [ ] AI機能をプレミアム機能として提供
- [ ] 収益モデルの多様化

## 収益化戦略

### 広告収益（Phase 2）
- **バナー広告**: 1クリック 10-50円
- **インタースティシャル**: 1表示 5-20円
- **想定収益**: 1,000ユーザーで月額5,000-10,000円

### プレミアム収益（Phase 4）
- **無料版**: 基本機能、月10回までのAI検索
- **プレミアム版**: 無制限AI検索、高度な分析（月額300-500円）

## 競合分析

### 主要競合
- Notion AI (月額$10)
- Obsidian (プラグイン有料)
- Roam Research (月額$15)
- Evernote (月額$14.99)

### 差別化ポイント
- **日本語特化**: 日本語文脈理解に特化
- **シンプルさ**: 「思い出す」ことに特化した機能
- **価格優位性**: 競合の1/3〜1/5の価格設定
- **モバイルファースト**: スマホでの使いやすさ重視

## 技術メモ

### 重要なファイル
- `lib/models/memo.dart`: メモデータモデル
- `lib/services/data_service.dart`: ローカルJSON操作
- `lib/providers/data_provider.dart`: Riverpodプロバイダー
- `lib/screens/home_screen.dart`: ホーム画面（Twitter風UI）
- `lib/screens/memo_detail_screen.dart`: メモ詳細画面（リアルタイム更新対応）
- `lib/screens/create_memo_screen.dart`: メモ作成・編集画面
- `lib/screens/settings_screen.dart`: 設定画面
- `lib/screens/terms_screen.dart`: 利用規約画面
- `lib/screens/privacy_screen.dart`: プライバシーポリシー画面
- `docs/`: GitHub Pages公式サイト

### 開発コマンド
```bash
# 開発実行
flutter run --hot

# ビルド
flutter build apk --release
flutter build ios --release

# テスト
flutter test

# 依存関係
flutter pub get
```

### 既知の課題
- 特になし（基本機能は安定）

## 2025-07-15の作業記録

### 完了した作業
1. **AI検索機能の技術検討**
   - OpenAI Embeddings + ベクトル検索の技術調査
   - 無料運用可能な選択肢の検討
   - ローカルTF-IDF vs OpenAI API のコスト比較
   - フリーミアムモデルに適した実装方法の提案

2. **テーマカラーの適用**
   - アプリテーマカラーを#1565C0（深い青）に変更
   - Material Design 3のColorScheme対応
   - ライト・ダークテーマ両対応

3. **アプリアイコンの設定**
   - `assets/icon/app_icon.png`に配置
   - `flutter_launcher_icons`パッケージで全サイズ自動生成
   - Android・iOSの各解像度に対応

4. **アプリ表示名の設定**
   - Android: `AndroidManifest.xml`で「オモイダシ」に設定
   - iOS: `Info.plist`で「オモイダシ」に設定

5. **設定画面の実装**
   - アプリ情報（名前、バージョン）
   - 利用規約・プライバシーポリシーへのリンク
   - お問い合わせ・アプリ評価機能
   - `url_launcher`パッケージでメール・ストアリンク対応

6. **法的文書の作成**
   - 利用規約（`lib/screens/terms_screen.dart`）
   - プライバシーポリシー（`lib/screens/privacy_screen.dart`）
   - 日本法準拠、ローカル保存重視の内容

7. **GitHub Pages公式サイトの作成**
   - `docs/index.html`: アプリ紹介ページ
   - `docs/terms.html`: 利用規約
   - `docs/privacy.html`: プライバシーポリシー
   - レスポンシブデザイン対応
   - 公開URL: https://tomurango.github.io/omoidashi/

8. **Git管理の開始**
   - リポジトリ初期化
   - .gitignore設定
   - GitHub: https://github.com/tomurango/omoidashi
   - 初回コミット完了

### 技術的な修正
- `package_info_plus`のMissingPluginExceptionエラー修正
- StatelessWidgetでの`mounted`エラー修正
- `context.mounted`を使用した適切な非同期処理実装

## 2025-07-17の追加作業

### App Store 名前重複問題の解決
- **問題**: 「オモイダシ」が既にApp Storeで使用済み
- **1回目の対応**: App Store表示名を「オモイダシ - 思考整理メモ」に変更 → 失敗
- **2回目の対応**: Bundle Identifier を `com.tomurango.omoidashi.memo` に変更 → 失敗
- **最終対応**: アプリ名を「リメンモー - 思い出すメモアプリ」に完全変更

### アプリ名変更 (2025-07-17)
- **新アプリ名**: リメンモー - 思い出すメモアプリ
- **新デバイス表示名**: リメンモー
- **新Bundle ID**: com.tomurango.omoidashi.memo
- **新メールアドレス**: support@remenmemo.app
- **変更内容**:
  - 全ての画面・ファイルのタイトル更新
  - GitHub Pagesサイト全体の更新
  - 利用規約・プライバシーポリシーの全面改訂

### iOS Archive ビルド問題の解決
- CocoaPods設定の修正（platform :ios, '12.0' 有効化）
- xcconfig設定の修正（#include? → #include）
- Runner.xcworkspace の使用（Runner.xcodeproj ではない）

### 次回の作業項目
1. App Store Connect で「リメンモー - 思い出すメモアプリ」でアプリ作成
2. アプリストア審査用スクリーンショット作成
3. アプリ説明文・キーワード設定
4. リリース申請

---
*最終更新: 2025-07-17*
*次回更新予定: リリース後*