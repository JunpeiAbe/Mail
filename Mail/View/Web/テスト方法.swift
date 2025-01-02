/*
⭐️1. 通信エラーのテスト
通信エラー（例: ネットワークがオフライン）は、比較的簡単に再現できます。

テスト方法
・ネットワーク接続を無効化する: デバイスやシミュレータで Wi-Fi またはモバイルデータをオフにします。
・iOS のネットワークリンクコンディショナーを使用する: Network Link Conditioner を有効化して、ネットワークを意図的に不安定にします。
Xcode シミュレータでは使用できないため、実機でのテストが必要です。
 
確認内容
webView(_:didFailProvisionalNavigation:withError:) または webView(_:didFail:withError:) が呼び出され、適切なエラー処理が行われること。
 
⭐️2. DNS 解決エラーのテスト
DNS 解決エラー（例: ホストが見つからない）は、無効な URL を使用することで再現可能です。

テスト方法
・無効なドメイン名を使用: 存在しないドメイン名（例: https://nonexistent.example）を指定します。

webView.load(URLRequest(url: URL(string: "https://nonexistent.example")!))
 
確認内容
webView(_:didFailProvisionalNavigation:withError:) が呼び出され、適切なエラー処理が行われること。
 
⭐️3. 不正なレスポンスのテスト
レスポンスエラー（例: HTTP ステータスコードが 4xx または 5xx）は、テストサーバーやモックサーバーを使用して再現可能です。

テスト方法
・モックサーバーを使用する: ローカルまたはオンラインのモックサーバーを設定し、特定のステータスコード（例: 404, 500）を返すようにします。
・無効なエンドポイントを使用する: 存在しないAPIパス（例: https://example.com/invalid-path）を指定します。
 →https://example.comは実際に存在するドメインであるため、DNS解決できる。しかし、その配下に/invalid-pathは存在しないため404が返却される
確認内容
webView(_:decidePolicyFor:decisionHandler:) でレスポンスのステータスコードを確認し、不正なレスポンスを適切に処理できること。
*/

