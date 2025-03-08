import UIKit
/// 認証コード入力画面のビューモデル
@MainActor
final class AuthCodeViewControllerViewModel {
    /// エラーメッセージ
    var authCodeFieldErrorMessage: String = .init() {
        didSet {
            onButtonStateChanged?(isAuthCodeSendButtonEnabled)
        }
    }
    /// 認証コード
    var authCodeText: String? {
        didSet {
            onButtonStateChanged?(isAuthCodeSendButtonEnabled)
        }
    }
    /// 認証コード送信ボタンが有効かどうか
    var isAuthCodeSendButtonEnabled: Bool {
        /// 入力値が4文字かつエラーメッセージがない
        return authCodeText != nil && authCodeText?.count == 4 && authCodeFieldErrorMessage.isEmpty
    }
    /// ボタンの状態変更を通知するクロージャー
    var onButtonStateChanged: ((Bool) -> Void)?
    /// 認証コード送信ボタンタップ
    func authCodeSendButtonPressed() {
        // ボタンタップ時の処理
        print("認証コード送信")
    }
}
