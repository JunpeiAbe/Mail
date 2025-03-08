import UIKit
import SwiftUI
/// 認証コード入力画面
final class AuthCodeViewController: UIViewController {
    /// ビューモデル
    private let viewModel = AuthCodeViewControllerViewModel()
    /// 認証コード入力欄
    let authCodeTextField: CommonTextField = {
        let textField: CommonTextField = .init(
            placeholder: "0000",
            highlightBorderColor: .link,
            errorBorderColor: .systemRed,
            validator: AuthCodeValidator()
        )
        return textField
    }()
    /// 認証コード入力欄のエラーメッセージ表示ラベル
    let authCodeTextFieldErrorLabel: UILabel = {
        let label: UILabel = .init(
            text: "エラー",
            font: .systemFont(
                ofSize: 10,
                weight: .bold
            ),
            textColor: .systemRed
        )
        return label
    }()
    /// 認証コード送信ボタン
    let authCodeSendButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "認証コードを送信",
            cornerStyle: .capsule,
            normalColor: .link,
            disabledColor: .gray
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
        layout()
    }
    
    func setup() {
        setupTapGestureToDismissKeyboard()
        authCodeTextField.onValidationSuccess = { [weak self] in
            guard let self = self else { return }
            self.viewModel.authCodeFieldErrorMessage = authCodeTextField.errorMessage
            self.viewModel.authCodeText = authCodeTextField.text
            self.authCodeTextFieldErrorLabel.text = authCodeTextField.errorMessage
        }
        authCodeTextField.onValidationFailure = { [weak self] in
            guard let self = self else { return }
            self.viewModel.authCodeFieldErrorMessage = authCodeTextField.errorMessage
            self.viewModel.authCodeText = authCodeTextField.text
            self.authCodeTextFieldErrorLabel.text = authCodeTextField.errorMessage
        }
        viewModel.onButtonStateChanged = { [weak self] isEnabled in
            print(isEnabled)
            self?.authCodeSendButton.isEnabled = isEnabled
        }
    }
    
    func layout() {
        
        let errorMessageStackView: UIStackView = .init(
            arrangedSubviews: [authCodeTextFieldErrorLabel],
            axis: .vertical
        )
        
        let fieldAndButtonStackview: UIStackView = .init(
            arrangedSubviews: [
                authCodeTextField,
                errorMessageStackView,
                authCodeSendButton
            ],
            axis: .vertical,
            spacing: 16,
            directionalLayoutMargins: .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
        
        let contentStackView: UIStackView = .init(
            arrangedSubviews: [fieldAndButtonStackview],
            axis: .horizontal,
            alignment: .center
        )
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [contentStackView],
            axis: .vertical
        )
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor)
        authCodeSendButton.anchor(height: 44)
        authCodeTextField.anchor(height: 44)
    }
    /// 外部タップでキーボードを閉じる
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false // 他のビューのタップイベントを妨げない
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // キーボードを閉じる
    }
}

#Preview {
    let viewController: AuthCodeViewController = {
        let vc: AuthCodeViewController = .init()
        return vc
    }()
    return UIViewControllerWrapper(viewController: viewController)
}
