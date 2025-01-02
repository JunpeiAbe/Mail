import UIKit
import SwiftUI
@preconcurrency import WebKit

final class WebViewController: UIViewController {
    
    /// webView
    let webView: WKWebView = {
        let configuration: WKWebViewConfiguration = .init()
        // defaultはnone
        configuration.dataDetectorTypes = .all
        let webView: WKWebView = .init(
            configuration: configuration,
            isScrollEnabled: true
        )
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        load()
    }
    
    private func setup() {
        webView.navigationDelegate = self
    }
    
    private func layout() {
        
        view.addSubview(webView)
        webView.anchor(
            top: view.topAnchor,
            left: view.leadingAnchor,
            bottom: view.bottomAnchor,
            right: view.trailingAnchor
        )
    }
    
    private func load() {
        // Webページをロード
        if let url = URL(string: "https://www.apple.com") {
            var request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// - MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    // ページ読み込み成功時
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    // ページ読み込み失敗時
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print("エラー: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == .linkActivated {
//            print("リンクを無効化")
//            decisionHandler(.cancel) // リンクを無効化
//        } else {
//            decisionHandler(.allow) // その他のアクションを許可
//        }
        decisionHandler(.allow)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let viewController = WebViewController()
    return UIViewControllerWrapper(viewController: viewController)
}
