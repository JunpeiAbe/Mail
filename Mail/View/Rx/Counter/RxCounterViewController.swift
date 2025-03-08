import UIKit
import SwiftUI
import RxSwift

final class RxCounterViewController: UIViewController {
    /// DisposeBag (RxSwiftのリソース管理用)
    private let disposeBag = DisposeBag()
    
    private var viewModel: RxCounterViewModel = .init()
    
    private let countLabel: UILabel = {
        let label: UILabel = .init(
            text: 0.description,
            font: .boldSystemFont(ofSize: 25),
            textAlignment: .center
        )
        return label
    }()
    
    private let incrementButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "Increment",
            cornerRadius: 8
        )
        return button
    }()
    
    private let decrementButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "Decrement",
            cornerRadius: 8
        )
        return button
    }()
    
    private let resetButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "Reset",
            cornerRadius: 8
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup() {
        let input = CounterViewModelInput(
            countUpButton: incrementButton.rx.tap.asObservable(),
            countDownButton: decrementButton.rx.tap.asObservable(),
            countResetButton: resetButton.rx.tap.asObservable()
        )
        viewModel.setup(input: input)
        viewModel.output?.counterText
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func layout() {
        
        let contentStackView: UIStackView = .init(
            arrangedSubviews: [
                countLabel,
                incrementButton,
                decrementButton,
                resetButton
            ],
            axis: .vertical,
            spacing: 16,
            alignment: .center
        )
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [
                contentStackView
            ],
            axis: .horizontal,
            alignment: .center
        )
        view.addSubview(mainStackView)
        mainStackView
            .anchor(
                top: view.topAnchor,
                left: view.leadingAnchor,
                bottom: view.bottomAnchor,
                right: view.trailingAnchor
            )
        incrementButton.anchor(height: 44)
        decrementButton.anchor(height: 44)
        resetButton.anchor(height: 44)
    }
}

#Preview {
    let viewController: RxCounterViewController = {
        let vc: RxCounterViewController = .init()
        return vc
    }()
    UIViewControllerWrapper(viewController: viewController)
}
