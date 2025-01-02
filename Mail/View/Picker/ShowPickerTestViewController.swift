import UIKit
import SwiftUI

final class ShowPickerTestViewController: UIViewController {
    
    private lazy var showDatePickerButton: CommonButton = {
        let button: CommonButton = .init(
            title: "showDatePicker",
            titleColor: .black,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            borderWidth: 1,
            borderColor: .black,
            normalColor: .white,
            highlightedColor: .white.withAlphaComponent(0.8)
        )
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        return button
    }()
    
    let datePickerViewController: DatePickerViewController = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup() {
        datePickerViewController.cancelButtonAction = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        datePickerViewController.doneButtonAction = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [showDatePickerButton],
            axis: .horizontal,
            directionalLayoutMargins: .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            alignment: .center
        )
        view.addSubview(mainStackView)
        showDatePickerButton.anchor(height: 44)
        mainStackView
            .anchor(
                top: view.topAnchor,
                left: view.leadingAnchor,
                bottom: view.bottomAnchor,
                right: view.trailingAnchor
            )
    }
    
    @objc func showDatePicker() {
        datePickerViewController.modalPresentationStyle = .custom
        datePickerViewController.transitioningDelegate = self
        present(datePickerViewController, animated: true)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ShowPickerTestViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: Preview
#Preview(traits: .sizeThatFitsLayout) {
    let viewController = ShowPickerTestViewController()
    UIViewControllerWrapper(viewController: viewController)
}
