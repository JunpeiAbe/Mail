import UIKit
import SwiftUI
@preconcurrency import WebKit

//参考: https://qiita.com/ymp-a/items/951c55a1c0f1bc1607d4
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
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// - MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    /// ページ読み込み完了時😄
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    /// ナビゲーションリクエストの許可または拒否(タイミング：リクエスト前)🤔
    /// - note: 指定された設定やアクション（タップなど）に基づいて、新しいコンテンツに移動する許可または拒否を応答
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    /// ナビゲーションリクエストの許可または拒否(タイミング：レスポンス後)🤔
    /// - note:  webViewが元のURLリクエストに対する応答を受信した後、ナビゲーションリクエストを許可または拒否するには、このメソッドを使用
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        return .allow
    }
    /// リクエストのロード進行状況の追跡(タイミング：ページ読み込み開始前)🔍
    /// - note: ナビゲーションリクエストを処理するための暫定的な承認を受け取った後、そのリクエストに対するレスポンスを受け取る前にこのメソッドを呼び出し
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation navigation: WKNavigation!")
    }
    /// リクエストのロード進行状況の追跡(タイミング：ページ読み込み開始時)🔍
    /// - note: WebViewがメインフレームのコンテンツの受信を開始したときに呼ばれます。webView(_:decidePolicyFor:decisionHandler:)がナビゲーションのレスポンスを承認した後、WebViewは処理を開始、変更の準備が整うと、WebViewはメインフレームを更新し始める前に、このメソッドを呼び出し
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit navigation: WKNavigation!")
    }
    /// リクエストのロード進行状況の追跡(タイミング：リダイレクト時)
    ///  - note: WebViewが要求のサーバーリダイレクトを受信したときに呼び出し🔍
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation: WKNavigation!")
    }
    /// 認証対応(タイミング：認証が必要な時)🔑
    ///  - note: 認証チャレンジ（HTTPSのサーバ認証やHTTP Basic認証、Digest認証など）に応答する時に呼ばれます。このメソッドを実装しない場合、WebViewはURLSession.AuthChallengeDisposition.rejectProtectionSpaceで認証チャレンジに応答
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("didReceive challenge: URLAuthenticationChallenge")
        completionHandler(.useCredential, nil)
    }
    /// エラー対応😭
    /// - note: ページ読み込み途中でのエラー発生時（HTML読み込み中のキャンセルなど）に呼び出し
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print("エラー: \(error.localizedDescription)")
    }
    /// エラー対応😭
    /// - note: ページ読み込み開始時でのエラー発生時（通信圏外など）に呼び出し
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("didFailProvisionalNavigation navigation: WKNavigation!")
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    let viewController = WebViewController()
    return UIViewControllerWrapper(viewController: viewController)
}
