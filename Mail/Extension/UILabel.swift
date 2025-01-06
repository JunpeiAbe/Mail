import UIKit
import SwiftUI

extension UILabel {
    /// プロパティを簡易に設定できるイニシャライザ
    /// lineBreakMode：byCharWrapping: 文字ごとに改行, byWordWrapping: 単語ごとに改行
    /// - note: 日本語のみテキストではbyCharWrappingで良い(単語の境界が英語よりも曖昧であり、読みやすさに影響しないから)
    /// - note: 日本語と英語の混在テキストでは単語単位の読みやすさを優先しbyWordWrappingを使用で良い
    convenience init(
        text: String? = nil,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .black,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        lineBreakMode: NSLineBreakMode = .byCharWrapping
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
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
        /// lineSpacing = 想定する行間 - (lineHeight - fontSize)より算出
        let lineSpacing = spacing - (self.font.lineHeight - self.font.pointSize)
        paragraphStyle.lineSpacing = lineSpacing
        
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
/// ラベルにlineHegihtを設定
/// lineheight：各行のbaselineの大きさ
/// - note: UIFontにはデフォルトでlineheightが設定されているためlineSpacing + フォントサイズでは目的のlineHeightにはならないので注意
/// lineSpacing = 想定する行間 - (lineHeight - fontSize)
/// 参考: https://speakerdeck.com/rockname/things-to-keep-in-mind-when-setting-line-height-in-your-ios-app?slide=10
#Preview("fontのlineHeightを考慮",traits: .sizeThatFitsLayout) {

    let multilineLabel: UILabel = {
        let label: UILabel = .init(
            text: "Swift was first introduced by Apple in 2014 and has rapidly evolved since then. This language aims to overcome the shortcomings of C and Objective-C, providing a safer and more efficient development environment. ",
            font: .systemFont(ofSize: 25),
            numberOfLines: 0,
            lineBreakMode: .byWordWrapping
        )
        label.setLineSpacing(5)
        print("fontのlineHeight:",label.font.lineHeight) // 文字サイズが25の場合、29.833984375
        print("lineSpcaing追加後のlineHeight:", label.font.lineHeight + 5) //文字サイズが25の場合、34.833984375
        return label
    }()
    
    let multilineLabel2: UILabel = {
        let label: UILabel = .init(
            text: "Swiftは2014年にAppleによって初めて発表され、その後急速に進化を遂げました。この言語は、C言語やObjective-Cの欠点を克服し、より安全で効率的な開発環境を提供することを目的としています。",
            font: .systemFont(ofSize: 25),
            numberOfLines: 0
        )
        label.setLineSpacing(5)
        print("fontのlineHeight:",label.font.lineHeight) // 文字サイズが25の場合、29.833984375
        print("lineSpcaing追加後のlineHeight:", label.font.lineHeight + 5) //文字サイズが25の場合、34.833984375
        return label
    }()
    
    let mainStackView: UIStackView = .init(
        arrangedSubviews: [multilineLabel, multilineLabel2],
        axis: .vertical,
        directionalLayoutMargins: .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    )
    
    UIViewWrapper(view: mainStackView)
        .frame(width: 300, height: .infinity)
}


