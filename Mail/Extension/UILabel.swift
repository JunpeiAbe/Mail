import UIKit

extension UILabel {
    /// プロパティを簡易に設定できるイニシャライザ
    convenience init(
        text: String? = nil,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .black,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    /// ラベルのスタイルをまとめて設定(ラベルの表示内容を変更する場合などに便利)
    func setStyle(
        text: String? = nil,
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil,
        numberOfLines: Int? = nil
    ) {
        if let text = text {
            self.text = text
        }
        if let font = font {
            self.font = font
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
    }
    /// 行間設定
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
        
        self.attributedText = attributedString
    }
    /// 特定の文字列にスタイルを適用
    func setAttributedText(for target: String, with attributes: [NSAttributedString.Key: Any]) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: target)
        attributedString.addAttributes(attributes, range: range)
        self.attributedText = attributedString
    }
}
