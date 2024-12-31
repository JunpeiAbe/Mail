import UIKit
import SwiftUI
// - TODO: 画像を重ねて背景色を変更+clipすると影が消える
extension UIButton {
    /// プロパティを簡易に設定できるイニシャライザ
    convenience init(
        title: String,
        titleColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 16),
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 1.0,
        shadowOffset: CGSize = CGSize(width: 0, height: 8),
        shadowRadius: CGFloat = 4,
        normalColor: UIColor,
        highlightedColor: UIColor? = nil,
        disabledColor: UIColor? = nil,
        selectedColor: UIColor? = nil
    ) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        self.setBackgroundImage(UIImage(color: normalColor), for: .normal)
        
        if let highlightedColor = highlightedColor {
            self.setBackgroundImage(UIImage(color: highlightedColor), for: .highlighted)
        }
        
        if let disabledColor = disabledColor {
            self.setBackgroundImage(UIImage(color: disabledColor), for: .disabled)
        }
        
        if let selectedColor = selectedColor {
            self.setBackgroundImage(UIImage(color: selectedColor), for: .selected)
        }
    }
    
    /// ボタンの状態に応じた背景色を設定
    /// - Parameters:
    ///   - normalColor: 活性時の背景色
    ///   - highlightedColor: ハイライト時の背景色
    ///   - disabledColor: 非活性時の背景色
    ///   - selectedColor: 選択時の背景色
    func setBackgroundColors(
        normalColor: UIColor,
        highlightedColor: UIColor? = nil,
        disabledColor: UIColor? = nil,
        selectedColor: UIColor? = nil
    ) {
        self.setBackgroundImage(UIImage(color: normalColor), for: .normal)
        
        if let highlightedColor = highlightedColor {
            self.setBackgroundImage(UIImage(color: highlightedColor), for: .highlighted)
        }
        
        if let disabledColor = disabledColor {
            self.setBackgroundImage(UIImage(color: disabledColor), for: .disabled)
        }
        
        if let selectedColor = selectedColor {
            self.setBackgroundImage(UIImage(color: selectedColor), for: .selected)
        }
    }
}

/// 背景色用のUIImageを生成する便利なExtension
private extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}

#Preview("Button1-normal",traits: .sizeThatFitsLayout) {
    var button: UIButton = {
        let button: UIButton = .init(
            title: "Button1",
            normalColor: .systemBlue,
            disabledColor: .systemGray
        )
        button.clipsToBounds = true
        return button
    }()
    UIViewWrapper(view: button)
        .frame(height: 44)
        .padding()
}

#Preview("Button1-disabled",traits: .sizeThatFitsLayout) {
    var button: UIButton = {
        let button: UIButton = .init(
            title: "Button1",
            normalColor: .systemBlue,
            disabledColor: .systemGray
        )
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    UIViewWrapper(view: button)
        .frame(height: 44)
        .padding()
}
