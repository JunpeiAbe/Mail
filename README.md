# Mail

UIKit ベースの iOS サンプルプロジェクトです。メール一覧 UI を中心に、カスタム UI コンポーネント、RxSwift/RxCocoa、RealmSwift、WebView、Picker、CollectionView、Slider などの実装例を確認できます。

## 開発環境

- Xcode 16 以降
- Swift 5
- iOS 26.0 以降
- UIKit

## 使用ライブラリ

Swift Package Manager で以下のライブラリを利用しています。

- RxSwift 6.8.0
- RxCocoa 6.8.0
- RealmSwift

パッケージ情報は `Mail.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` で管理されています。

## セットアップ

1. リポジトリをクローンします。
2. `Mail.xcodeproj` を Xcode で開きます。
3. Xcode が Swift Package Manager の依存関係を解決するまで待ちます。
4. Scheme に `Mail` を選択し、任意の iOS Simulator または実機で Run します。

## プロジェクト構成

```text
Mail/
├── API/              # API・Repository
├── Assets.xcassets/  # 画像・色アセット
├── Const/            # 定数
├── Database/         # Realm 関連
├── Extension/        # UIKit などの拡張
├── Model/            # データモデル
├── Protocols/        # プロトコル
├── View/             # UIViewController・カスタム View
└── ViewModel/        # ViewModel
```

## 主な画面・実装例

- `MailListViewController`: メール一覧、編集、削除、フィルター用モーダル
- `RealmViewController`: RealmSwift の保存・取得・削除処理
- `RxCounterViewController`: RxSwift を使ったカウンター
- `RxAuthViewController`: RxSwift を使った認証系 UI
- `WebViewController`: WKWebView の表示・操作
- `IconListViewController`: CollectionView の実装例
- `VideoProgresSliderViewController`: カスタム Slider の実装例
- `GradientSegmentControl`: グラデーション付き SegmentControl

現在の起動画面は `SceneDelegate.swift` の `rootViewController` で指定されています。確認したい画面に切り替える場合は、該当する ViewController を `rootViewController` に設定してください。

## ビルド

Xcode から Run するか、コマンドラインで以下を実行します。

```sh
xcodebuild -project Mail.xcodeproj -scheme Mail -destination 'platform=iOS Simulator,name=iPhone 16' build
```

利用できる Simulator 名は環境によって異なるため、必要に応じて `xcrun simctl list devices` で確認してください。

## 備考

- UI は主にコードベースで構築されています。
- `Main.storyboard` と `LaunchScreen.storyboard` はプロジェクトに含まれていますが、起動時の root view controller は `SceneDelegate.swift` で設定されています。
- テストターゲットは現時点では含まれていません。
