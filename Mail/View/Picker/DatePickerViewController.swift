import UIKit
import SwiftUI
/// 日付選択ピッカー
final class DatePickerViewController: UIViewController {
    
    var cancelButtonAction: (() -> Void)?
    var doneButtonAction: (() -> Void)?
    
    /// 日付選択ピッカー
    private let datePicker: UIDatePicker = {
        let picker: UIDatePicker = .init()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ja_JP") // 日本のロケールを設定
        return picker
    }()
    /// doneボタン
    private lazy var doneButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    /// cancelボタン
    private lazy var cancelButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup() {
        // 最小日付
        let minimumDate: Date = .now
        // 最大日付(最小+10日後)
        let maximumDate: Date = Calendar.current.date(byAdding: .day, value: 10, to: minimumDate) ?? minimumDate
        print("最小日付:",minimumDate.toString(format: .yyyyMMddHHmmss_slash_colon))
        print("最大日付:",maximumDate.toString(format: .yyyyMMddHHmmss_slash_colon))
        // UIDatePicker に最小・最大日付を設定
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.date = minimumDate // 初期値を最小値
    }
    
    func layout() {
        let cancelButtonStackView: UIStackView = .init(
            arrangedSubviews: [cancelButton],
            axis: .vertical,
            distribution: .fill,
            alignment: .leading
        )
        let doneButtonStackView: UIStackView = .init(
            arrangedSubviews: [doneButton],
            axis: .vertical,
            distribution: .fill,
            alignment: .trailing
        )
        let toolBarStackView: UIStackView = .init(
            arrangedSubviews: [cancelButtonStackView, doneButtonStackView],
            axis: .horizontal,
            directionalLayoutMargins: .init(top: 8, leading: 8, bottom: 8, trailing: 8),
            distribution: .fill
        )
        toolBarStackView.backgroundColor = .systemGray6
        let datePickerStackView: UIStackView = .init(
            arrangedSubviews: [datePicker],
            axis: .vertical,
            distribution: .fill
        )
        datePickerStackView.backgroundColor = .gray.withAlphaComponent(0.2)
        let modalStackView: UIStackView = .init(
            arrangedSubviews: [toolBarStackView, datePickerStackView],
            axis: .vertical,
            isLayoutMarginsRelativeArrangement: false
        )
        modalStackView.backgroundColor = .white
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [modalStackView],
            axis: .horizontal,
            isLayoutMarginsRelativeArrangement: false,
            alignment: .bottom
        )
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor)
    }
    
    @objc func cancelButtonTapped() {
        print("cancel")
        cancelButtonAction?()
    }
    
    @objc func doneButtonTapped() {
        // 呼び出し元で最新値を取得するためにdoneタップ時に呼び出し元の画面に渡す
        /// - note: 呼び出し元でコンテンツをインスタンス化しているので引数はなくても良い
        print("done")
        doneButtonAction?()
    }
}

#Preview {
    let viewController: DatePickerViewController = .init()
    UIViewControllerWrapper(viewController: viewController)
}
