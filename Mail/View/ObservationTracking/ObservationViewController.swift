import UIKit
import SwiftUI

final class ObservationViewController: UIViewController {
    
    let viewModel: ObservationViewModel = .init()
    private let countLabel: UILabel = .init()
    private var countUpButton: UIButton = .init()
    private var countDownButton: UIButton = .init()
    private var selectButton: UIButton = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLoad()
        layout()
        bind()
    }
    
    func firstLoad() {
        countLabel.text = viewModel.countStr
        countUpButton
            .addTarget(
                self,
                action: #selector(
                    didTapCountUpButton
                ),
                for: .touchUpInside
            )
        countUpButton.setTitle("カウントアップ", for: .normal)
        countUpButton.setTitleColor(.blue, for: .normal)
        countDownButton
            .addTarget(
                self,
                action: #selector(
                    didTapCountDownButton
                ),
                for: .touchUpInside
            )
        countDownButton.setTitle("カウントダウン", for: .normal)
        countDownButton.setTitleColor(.blue, for: .normal)
        selectButton
            .addTarget(
                self,
                action: #selector(
                    didTapSelectButton
                ),
                for: .touchUpInside
            )
        selectButton.setTitle(viewModel.isSelectedStr, for: .normal)
        selectButton.setTitleColor(.red, for: .normal)
    }
    
    private func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [countLabel, countUpButton, countDownButton, selectButton],
            axis: .vertical,
            alignment: .center
        )
        view.addSubview(mainStackView)
        mainStackView
            .anchor(
                top: view.topAnchor,
                left: view.leadingAnchor,
                right: view.trailingAnchor
            )
    }
    
    func bind() {
        withObservationTracking { [weak self] in
            self?.countLabel.text = self?.viewModel.countStr
            self?.selectButton.setTitle(self?.viewModel.isSelectedStr, for: .normal)
        } onChange: { [weak self] in
            Task { @MainActor in
                self?.bind()
            }
        }
    }
    
    @objc
    func didTapCountUpButton() {
        print("didTapCountUpButton")
        viewModel.countUp()
    }
    
    @objc
    func didTapCountDownButton() {
        print("didTapCountDownButton")
        viewModel.countDown()
    }
    
    @objc
    func didTapSelectButton() {
        print("didTapSelectButton")
        viewModel.changeSelectState()
    }
}

// MARK: Preview
#Preview(traits: .sizeThatFitsLayout) {
    let viewController = ObservationViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    UIViewControllerWrapper(viewController: navigationController)
}
