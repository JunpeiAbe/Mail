import UIKit
import SwiftUI
/// Configurationでプロパティ指定したボタン
/// - note: ボタンの影以外はConfigurationより設定可
// - TODO: 共通のConfigurationを作成しプロパティ指定する
/// 参考: https://qiita.com/kurapy-n/items/c283d89d80bd48d40ab5
final class CommonButtonWithConfig: UIButton {
    /// カスタムイニシャライザ
    init(
        title: String? = nil,
        titleColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 16),
        cornerRadius: CGFloat = 0,
        cornerStyle: UIButton.Configuration.CornerStyle? = nil,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        shadowRadius: CGFloat = 8,
        normalColor: UIColor? = nil,
        highlightedColor: UIColor? = nil,
        disabledColor: UIColor? = nil,
        image: UIImage? = nil,
        imagePlacement: NSDirectionalRectEdge = .leading,
        imagePadding: CGFloat = 0
    ) {
        super.init(frame: .zero)

        // UIButton.Configuration を作成
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = titleColor // テキスト色
        config.baseBackgroundColor = normalColor // 通常背景色
        if let cornerStyle {
            config.cornerStyle = cornerStyle
        }
        // configからフォントの変更を適用するには以下のように行う
        let container = AttributeContainer([
            .font: font
        ])
        if let title {
            config.attributedTitle = AttributedString(title, attributes: container)
        }
        // ボーダーや線の太さはUIBackgroundConfigurationから設定する
        var backgroundConfig = UIBackgroundConfiguration.clear()
        backgroundConfig.strokeColor = borderColor
        backgroundConfig.strokeWidth = borderWidth
        backgroundConfig.cornerRadius = cornerRadius
        config.background = backgroundConfig
        // 画像の設定
        config.image = image
        // 画像の位置を設定
        config.imagePlacement = imagePlacement // 位置
        config.imagePadding = imagePadding // 余白
        
        self.configuration = config

        // 状態ごとの色を設定
        self.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                if let highlightedColor {
                    // ハイライト指定した場合、指定色+背景を暗くする(デフォルト)
                    button.configuration?.baseBackgroundColor = highlightedColor
                    button.configuration?.image = image?.withTintColor(highlightedColor, renderingMode: .alwaysTemplate)
                } else {
                    // ハイライト未指定の場合、通常色を基準に指定割合で暗くする
                    button.configuration?.baseBackgroundColor = normalColor?.darker(by: 50)
                    button.configuration?.image = image?.withTintColor(normalColor?.darker(by: 50) ?? .black, renderingMode: .alwaysTemplate)
                }
            case .disabled:
                button.configuration?.baseBackgroundColor = disabledColor ?? normalColor
                button.configuration?.image = image?.withTintColor(disabledColor ?? .black, renderingMode: .alwaysTemplate)
            default:
                button.configuration?.baseBackgroundColor = normalColor
                // デフォルトの画像色を適用するため、そのまま画像を指定
                // 現在のconfigurationの画像を参照する(タップ時の画像変更が反映されないため)
                if let customImage = button.configuration?.image {
                    button.configuration?.image = customImage
                }
            }
        }

        // ボーダー、影(影などはconfigから設定できないのでlayerプロパティから設定する)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommonButtonWithConfig {
    /// ボタン画像を更新するメソッド
    func updateImage(image: UIImage?) {
        guard let config = self.configuration else { return }
        var updatedConfig = config
        updatedConfig.image = image
        self.configuration = updatedConfig
    }
}

extension UIColor {
    /// 色を暗くするユーティリティ関数
    func darker(by percentage: CGFloat) -> UIColor? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        return UIColor(
            red: max(red - percentage / 100, 0),
            green: max(green - percentage / 100, 0),
            blue: max(blue - percentage / 100, 0),
            alpha: alpha
        )
    }
}

#Preview("CommonButton", traits: .sizeThatFitsLayout) {
    let button: CommonButtonWithConfig = {
        let button = CommonButtonWithConfig(
            title: "Common",
            titleColor: .white,
            font: .systemFont(ofSize: 12, weight: .bold),
            cornerRadius: 16,
            normalColor: .black,
            disabledColor: .systemGray,
            image: .add,
            imagePlacement: .bottom,
            imagePadding: 8
        )
        button.isEnabled = true // 活性化
        return button
    }()
    
    UIViewWrapper(view: button)
        .frame(width: 80, height: 80)
        .padding()
}

#Preview("CancelButton", traits: .sizeThatFitsLayout) {
    let cancelButton: CommonButtonWithConfig = {
        let button = CommonButtonWithConfig(
            title: "Cancel",
            titleColor: .black,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            borderWidth: 1,
            borderColor: .black,
            normalColor: .white,
            highlightedColor: .white
        )
        button.isEnabled = true // 活性化
        return button
    }()
    
    return UIViewWrapper(view: cancelButton)
        .frame(height: 44)
        .padding()
}

#Preview("ImageOnlyButton", traits: .sizeThatFitsLayout) {
    let cancelButton: CommonButtonWithConfig = {
        let button = CommonButtonWithConfig(
            titleColor: .systemGray4,
            shadowColor: .clear,
            normalColor: UIColor.clear,
            image: UIImage(systemName: "play.fill")
        )
        button.isEnabled = true // 活性化
        return button
    }()
    
    return UIViewWrapper(view: cancelButton)
        .frame(height: 44)
        .padding()
}

