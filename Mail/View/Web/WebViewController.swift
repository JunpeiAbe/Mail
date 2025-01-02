import UIKit
import SwiftUI
@preconcurrency import WebKit

//参考: https://qiita.com/ymp-a/items/951c55a1c0f1bc1607d4
/// - note:エラーハンドリングとしては以下の方針で行う
/*
 1. 通信エラーの処理
 WKNavigationDelegate の
 ・webView(_:didFail:withError:)
 ・webView(_:didFailProvisionalNavigation:withError:) を実装。
 didFailProvisionalNavigation: 初期リクエストの段階でエラーが発生した場合（例: ホストが見つからない、接続タイムアウト）。
 didFail: ページ読み込み中にエラーが発生した場合（例: サーバーエラー、接続切断）。
 2. 不正なレスポンスの処理
 webView(_:decidePolicyFor:decisionHandler:) を使用して、HTTP ステータスコードなどを確認し、不正なレスポンスをキャンセルします。
 */
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
        print("ページ読み込み完了")
    }
    /// ナビゲーションリクエストの許可または拒否(タイミング：リクエスト前)🤔
    /// - note: 指定された設定やアクション（タップなど）に基づいて、新しいコンテンツに移動する許可または拒否を応答
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("リクエスト前")
        decisionHandler(.allow)
    }
    /// ナビゲーションリクエストの許可または拒否(タイミング：レスポンス後)🤔
    /// - note:  webViewが元のURLリクエストに対する応答を受信した後、ナビゲーションリクエストを許可または拒否するには、このメソッドを使用
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        print("レスポンス後")
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            if !(200...299).contains(httpResponse.statusCode) {
                print("不正なレスポンス: \(httpResponse.statusCode)")
                UIAlertController
                    .show(
                        title: "レスポンスエラー",
                        message: "レスポンスエラーが発生しました。\nステータスコード: \(httpResponse.statusCode)",
                        presentingViewController: self
                    )
                return .cancel
            }
        }
        return .allow
    }
    /// リクエストのロード進行状況の追跡(タイミング：ページ読み込み開始前)🔍
    /// - note: ナビゲーションリクエストを処理するための暫定的な承認を受け取った後、そのリクエストに対するレスポンスを受け取る前にこのメソッドを呼び出し
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("ページ読み込み開始前")
    }
    /// リクエストのロード進行状況の追跡(タイミング：ページ読み込み開始時)🔍
    /// - note: WebViewがメインフレームのコンテンツの受信を開始したときに呼ばれます。webView(_:decidePolicyFor:decisionHandler:)がナビゲーションのレスポンスを承認した後、WebViewは処理を開始、変更の準備が整うと、WebViewはメインフレームを更新し始める前に、このメソッドを呼び出し
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("ページ読み込み開始")
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
        print("認証チャレンジ")
        completionHandler(.useCredential, nil)
    }
    /// エラー対応😭
    /// - note: ページ読み込み途中でのエラー発生時（HTML読み込み中のキャンセルなど）に呼び出し
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print("ページ読み込み途中でのエラー")
        UIAlertController
            .show(
                title: "ページ読み込み途中エラー",
                message: "ページの読み込みに失敗しました。\nエラー: \(error.localizedDescription)",
                presentingViewController: self
            )
    }
    /// エラー対応😭
    /// - note: ページ読み込み開始時でのエラー発生時（通信圏外など）に呼び出し
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("ページ読み込み開始でのエラー")
        UIAlertController
            .show(
                title: "ページ読み込み開始エラー",
                message: "ページの読み込みに失敗しました。\nエラー: \(withError.localizedDescription)",
                presentingViewController: self
            )
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    let viewController = WebViewController()
    return UIViewControllerWrapper(viewController: viewController)
}
