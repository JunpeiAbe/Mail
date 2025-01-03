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
    
    private lazy var showCalenderPopupButton: CommonButton = {
        let button: CommonButton = .init(
            title: "showCalenderPopup",
            titleColor: .black,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            borderWidth: 1,
            borderColor: .black,
            normalColor: .white,
            highlightedColor: .white.withAlphaComponent(0.8)
        )
        button.addTarget(self, action: #selector(showCalenderPopup), for: .touchUpInside)
        return button
    }()
    
    let datePickerViewController: DatePickerViewController = .init()
    let calenderPopupViewController: CalenderPopupViewController = .init()
    
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
        calenderPopupViewController.cancelButtonAction = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        calenderPopupViewController.doneButtonAction = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    func layout() {
        let buttonsStackView: UIStackView = .init(
            arrangedSubviews: [showDatePickerButton, showCalenderPopupButton],
            axis: .vertical,
            spacing: 16,
            distribution: .fill,
            alignment: .fill
        )
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [buttonsStackView],
            axis: .horizontal,
            directionalLayoutMargins: .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            distribution: .fillProportionally,
            alignment: .center
        )
        view.addSubview(mainStackView)
        showDatePickerButton.anchor(height: 44)
        showCalenderPopupButton.anchor(height: 44)
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
    
    @objc func showCalenderPopup() {
        // モーダル表示
        calenderPopupViewController.modalPresentationStyle = .overCurrentContext
        calenderPopupViewController.modalTransitionStyle = .crossDissolve
        present(calenderPopupViewController, animated: true)
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
