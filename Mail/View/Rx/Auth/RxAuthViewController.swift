import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class RxAuthViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    /// メールアドレス入力欄
    let emailTextField: UITextField = {
        let textField: UITextField = .init(
            placeholder: "メールアドレス",
            borderColor: .systemGray5
        )
        return textField
    }()
    /// パスワード入力欄
    let passwordTextField: UITextField = {
        let textField: UITextField = .init(
            placeholder: "パスワード",
            borderColor: .systemGray5
        )
        return textField
    }()
    /// パスワード（再入力）入力欄
    let passwordConfirmTextField: UITextField = {
        let textField: UITextField = .init(
            placeholder: "パスワード（再入力)",
            borderColor: .systemGray5
        )
        return textField
    }()

    /// 認証ボタン
    let signupButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "サインアップ",
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
        
//        emailTextField.rx.text
//            .map { $0 ?? "" }
//            .map { $0.isValidEmail }
//            .bind(to: signupButton.rx.isEnabled) // mapで変換したBoolから判定
//            .disposed(by: disposeBag)
//        
//        passwordTextField.rx.text
//            .map { $0 ?? "" }
//            .map { $0.isValidPassword }
//            .bind(to: signupButton.rx.isEnabled) // mapで変換したBoolから判定
//            .disposed(by: disposeBag)
//        
//        passwordConfirmTextField.rx.text
//            .map { $0 ?? "" }
//            .map { $0.isValidPassword }
//            .bind(to: signupButton.rx.isEnabled) // mapで変換したBoolから判定
//            .disposed(by: disposeBag)
        
        // パスワードの比較
//        Observable
//            .combineLatest(
//                passwordTextField.rx.text,
//                passwordConfirmTextField.rx.text
//            )
//            .map { pass1, pass2 in pass1 == pass2 }
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                emailTextField,rx.text.map { $0 ?? "" },
                passwordTextField.rx.text.map { $0 ?? "" },
                passwordConfirmTextField.rx.text.map { $0 ?? "" }
            )
            .map { email, pass1, pass2 in
                email.isValidEmail
                && pass1.isValidPassword
                && pass2.isValidPassword
                && pass1 == pass2
            }
            .bind(to: signupButton.rx.isEnabled) // mapで変換したBoolから判定
            .disposed(by: disposeBag)
    }
    
    func layout() {
        let fieldAndButtonStackview: UIStackView = .init(
            arrangedSubviews: [
                emailTextField,
                passwordTextField,
                passwordConfirmTextField,
                signupButton
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
        
        emailTextField.anchor(height: 44)
        
        passwordTextField.anchor(height: 44)
        
        passwordConfirmTextField.anchor(height: 44)
        
        signupButton.anchor(height: 44)
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

private extension String {
    var isValidEmail: Bool {
        contains("@gmail.com")
    }
    var isValidPassword: Bool {
        count >= 8
    }
}

#Preview {
    let viewController: RxAuthViewController = {
        let vc: RxAuthViewController = .init()
        return vc
    }()
    return UIViewControllerWrapper(viewController: viewController)
}
