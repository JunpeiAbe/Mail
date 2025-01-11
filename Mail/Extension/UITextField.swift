import UIKit
import SwiftUI
/// 入力欄の拡張
extension UITextField {
    // プレースホルダーの色を設定
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    // テキストフィールドのボーダー色を変更
    func setBorderColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
    
    // バリデーション: 必須チェック
    func validateRequired() -> Bool {
        return !(self.text ?? "").isEmpty
    }
    
    // バリデーション: 正規表現チェック
    func validateWithRegex(_ regex: String) -> Bool {
        guard let text = self.text else { return false }
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    // 共通のスタイルを簡単に設定できるイニシャライザ
    convenience init(
        placeholder: String? = nil,
        font: UIFont? = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .black,
        borderColor: UIColor = .gray,
        cornerRadius: CGFloat = 8.0,
        borderWidth: CGFloat = 1.0
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.font = font
        self.textColor = textColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
