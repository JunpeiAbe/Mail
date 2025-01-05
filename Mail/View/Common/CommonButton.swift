import UIKit
import SwiftUI
/// 汎用ボタンクラス
/// - note: Configurationを使用していない(デフォルトがPlainボタン)
final class CommonButton: UIButton {
    /// 通常背景色
    var normalColor: UIColor?
    /// 非活性背景色
    var disabledColor: UIColor?
    /// タップ時背景色
    var highlightedColor: UIColor?

    /// 活性状態
    /// - note: 変更時に背景色変更を反映
    override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    /// タップ状態
    /// - note: 変更時に背景色変更を反映
    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    /// カスタムイニシャライザ
    init(
        title: String,
        titleColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 16),
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        shadowRadius: CGFloat = 8,
        normalColor: UIColor? = nil,
        disabledColor: UIColor? = nil,
        highlightedColor: UIColor? = nil
    ) {
        self.normalColor = normalColor
        self.disabledColor = disabledColor
        self.highlightedColor = highlightedColor
        super.init(frame: .zero)
        
        // ボタンの見た目を設定
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.backgroundColor = normalColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 背景色の更新
    private func updateBackgroundColor() {
        if !isEnabled {
            backgroundColor = disabledColor ?? normalColor
        } else if isHighlighted {
            backgroundColor = highlightedColor ?? normalColor
        } else {
            backgroundColor = normalColor
        }
    }
}


#Preview("CommonButton", traits: .sizeThatFitsLayout) {
    let button: CommonButton = {
        let button = CommonButton(
            title: "common",
            titleColor: .white,
            font: .systemFont(ofSize: 16),
            cornerRadius: 16,
            normalColor: .blue,
            disabledColor: .cyan,
            highlightedColor: .blue.withAlphaComponent(0.5)
        )
        return button
    }()
    
    UIViewWrapper(view: button)
        .frame(height: 44)
        .padding()
}

#Preview("CancelButton", traits: .sizeThatFitsLayout) {
    let cancelButton: CommonButton = {
        let button: CommonButton = .init(
            title: "Cancel",
            titleColor: .black,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            borderWidth: 1,
            borderColor: .black,
            normalColor: .white,
            highlightedColor: .white.withAlphaComponent(0.8)
        )
        return button
    }()
    
    UIViewWrapper(view: cancelButton)
        .frame(height: 44)
        .padding()
}
