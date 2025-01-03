import UIKit
import SwiftUI

final class CalenderPopupViewController: UIViewController {
    
    var cancelButtonAction: (() -> Void)?
    var doneButtonAction: (() -> Void)?
    
    /// ポップアップの背景
    private let popupBackgroundView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        return view
    }()
    /// 日付選択ピッカー
    private let calenderDatePicker: UIDatePicker = {
        let picker: UIDatePicker = .init()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ja_JP") // 日本のロケールを設定
        return picker
    }()
    /// 時間選択ピッカー
    /// - note: wheel形式で時間選択するために、カレンダーとは別に作成
    private let timeDatePicker: UIDatePicker = {
        let picker: UIDatePicker = .init()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ja_JP") // 日本のロケールを設定
        return picker
    }()
    
    /// ディバイダーイメージ
    private let dividerImage: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemGray
        return view
    }()
    /// セパレーターイメージ
    private let separatorImage: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemGray
        return view
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
        calenderDatePicker.minimumDate = minimumDate
        calenderDatePicker.maximumDate = maximumDate
        calenderDatePicker.date = minimumDate // 初期値を最小値
    }
    
    func layout() {
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        let buttonsStackView: UIStackView = .init(
            arrangedSubviews:[cancelButton, separatorImage, doneButton] ,
            axis: .horizontal,
            distribution: .fillProportionally
        )
        
        let contentStackView: UIStackView = .init(
            arrangedSubviews: [calenderDatePicker, timeDatePicker, dividerImage, buttonsStackView],
            axis: .vertical
        )
        
        popupBackgroundView.addSubview(contentStackView)
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [popupBackgroundView],
            axis: .horizontal,
            directionalLayoutMargins: .init(
                top: 0,
                leading: 32,
                bottom: 0,
                trailing: 32
            ), alignment: .center
        )
        view.addSubview(mainStackView)
        separatorImage.anchor(width: 0.5)
        dividerImage.anchor(height: 0.5)
        cancelButton.anchor(height: 48)
        doneButton.anchor(height: 48)
        contentStackView.anchor(
            top: popupBackgroundView.topAnchor,
            left: popupBackgroundView.leadingAnchor,
            bottom: popupBackgroundView.bottomAnchor,
            right: popupBackgroundView.trailingAnchor
        )
        mainStackView.anchor(
            top: view.topAnchor,
            left: view.leadingAnchor,
            bottom: view.bottomAnchor,
            right: view.trailingAnchor
        )
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
    let viewController: CalenderPopupViewController = .init()
    UIViewControllerWrapper(viewController: viewController)
}
