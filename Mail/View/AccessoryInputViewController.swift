import UIKit

class AccessoryInputViewController: UIViewController {

    private let showSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("入力シートを表示", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let dummyTextField = UITextField(
        placeholder: nil,
        borderColor: .clear,
        cornerRadius: 0,
        borderWidth: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        setupDummyInputField()
    }

    private func setupUI() {
        view.addSubview(showSheetButton)
        showSheetButton.centerInSuperview(width: 200, height: 50)
        showSheetButton.addTarget(self, action: #selector(showAccessorySheet), for: .touchUpInside)
    }

    private func setupDummyInputField() {
        dummyTextField.isHidden = true
        dummyTextField.inputAccessoryView = createAccessoryView()
        view.addSubview(dummyTextField)
    }

    @objc private func showAccessorySheet() {
        dummyTextField.becomeFirstResponder()
    }

    @objc private func dismissAccessorySheet() {
        dummyTextField.resignFirstResponder()
    }

    private func createAccessoryView() -> UIView {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("閉じる", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        closeButton.addTarget(self, action: #selector(dismissAccessorySheet), for: .touchUpInside)

        let stack = UIStackView(
            arrangedSubviews: [UIView(), closeButton],
            axis: .horizontal,
            spacing: 8,
            directionalLayoutMargins: .init(top: 10, leading: 16, bottom: 10, trailing: 16),
            distribution: .equalSpacing,
            alignment: .center
        )
        stack.backgroundColor = .systemGray5
        stack.anchor(height: 50)

        return stack
    }
}

struct AccessoryInputViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerWrapper(viewController: AccessoryInputViewController())
            .edgesIgnoringSafeArea(.all)
    }
}
