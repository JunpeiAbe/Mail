import UIKit
import SwiftUI

extension UIAlertController {
    /// アラートを表示する
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - actions: アクションの配列。デフォルトで "OK" ボタンが追加されます。
    ///   - preferredStyle: アラートのスタイル（デフォルトは `.alert`）
    ///   - presentingViewController: アラートを表示するビューコントローラー
    static func show(
        title: String?,
        message: String?,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)],
        preferredStyle: UIAlertController.Style = .alert,
        presentingViewController: UIViewController
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alertController.addAction($0) }
        presentingViewController.present(alertController, animated: true, completion: nil)
    }

    /// 簡易アクション付きアラート
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - presentingViewController: アラートを表示するビューコントローラー
    ///   - confirmTitle: 確認ボタンのタイトル（デフォルト: "OK"）
    ///   - confirmAction: 確認ボタンのアクション（デフォルト: nil）
    ///   - cancelTitle: キャンセルボタンのタイトル（デフォルト: "Cancel"）
    ///   - cancelAction: キャンセルボタンのアクション（デフォルト: nil）
    static func showWithActions(
        title: String?,
        message: String?,
        presentingViewController: UIViewController,
        confirmTitle: String = "OK",
        confirmAction: ((UIAlertAction) -> Void)? = nil,
        cancelTitle: String = "Cancel",
        cancelAction: ((UIAlertAction) -> Void)? = nil
    ) {
        let confirm = UIAlertAction(title: confirmTitle, style: .default, handler: confirmAction)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelAction)
        show(
            title: title,
            message: message,
            actions: [confirm, cancel],
            presentingViewController: presentingViewController
        )
    }
}

#Preview {
    /// アラートをプレビュー表示するためのカスタム UIViewController
    final class AlertPreviewViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            
            // UIAlertController の作成
//            let alert = UIAlertController(
//                title: "プレビューアラート",
//                message: "これはUIAlertControllerのプレビューです。",
//                preferredStyle: .alert
//            )
//            
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            alert
//                .addAction(
//                    UIAlertAction(
//                        title: "キャンセル",
//                        style: .cancel,
//                        handler: {_ in self.present(alert, animated: true, completion: nil)}
//                    )
//                )
//            
//            // アラートを表示
//            DispatchQueue.main.async {
//                self.present(alert, animated: true, completion: nil)
//            }
            /// 省略形
            DispatchQueue.main.async {
                UIAlertController
                    .show(
                        title: "アラート",
                        message: "これはUIAlertControllerのプレビューです。",
                        presentingViewController: self
                    )
            }
        }
    }
    return UIViewControllerWrapper(viewController: AlertPreviewViewController())
                .edgesIgnoringSafeArea(.all)
}
