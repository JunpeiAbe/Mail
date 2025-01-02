import UIKit
import SwiftUI
@preconcurrency import WebKit

extension WKWebView {
    /// URL を簡単に読み込むためのイニシャライザ
    /// - Parameters:
    ///   - configuration: `WKWebViewConfiguration`（オプション、デフォルトで標準設定を使用）
    ///   - allowsBackForwardNavigationGestures: スワイプによる進む/戻るを有効にするか（デフォルトは `true`）
    ///   - isJavaScriptEnabled: JavaScript を有効にするか（デフォルトは `true`）
    ///   - isScrollEnabled: スクロールを有効にするか（デフォルトは `true`）
    convenience init(
        configuration: WKWebViewConfiguration = WKWebViewConfiguration(),
        allowsBackForwardNavigationGestures: Bool = true,
        isJavaScriptEnabled: Bool = true,
        isScrollEnabled: Bool = true
    ) {
        // JavaScript の有効化設定（推奨される方法）
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = isJavaScriptEnabled
        configuration.defaultWebpagePreferences = webpagePreferences
        
        // 初期化
        self.init(frame: .zero, configuration: configuration)
        
        // スワイプナビゲーションの有効化
        self.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        
        // スクロールの有効化
        self.scrollView.isScrollEnabled = isScrollEnabled
    }
}
