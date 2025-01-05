import UIKit
import SwiftUI
/*
1. plain()
シンプルなテキスト表示のボタン。
背景色や枠線はデフォルトで設定されない。
 
2. gray()
グレーの背景色を持つボタン。
テキストは黒または白（ダークモードの場合）で表示されない。

3. tinted()
ボタンの背景色が透過され、タッチ時に強調されるスタイル。
システムカラー（アクセントカラー）を基準に背景とテキストが設定される。
 
4. filled()
塗りつぶされた背景を持つボタン。
テキストと背景のコントラストが明確。
 
5. bordered()
背景色が透明で、枠線（ボーダー）が付いたボタン。
アクセントカラーが枠線とテキストに適用される。
 
6. borderedTinted()
枠線付きボタンですが、背景にアクセントカラーの薄いバージョンが設定されます。
選択時にさらに強調されます。
 
7. borderedProminent()
背景色が塗りつぶされ、枠線もアクセントカラーで表示されるスタイル。
強調表示が必要なボタンに適しています。
*/
#Preview("Button Comparisons Unified", traits: .sizeThatFitsLayout) {
    let stackView: UIStackView = {
        // 共通の設定値
        let commonForegroundColor: UIColor = .white
        let commonBackgroundColor: UIColor = .systemBlue
        let commonFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
        
        func createButton(configuration: UIButton.Configuration, title: String) -> UIButton {
            var config = configuration
            let button = UIButton()
            if configuration != .plain() {
                config.title = title
                config.baseForegroundColor = commonForegroundColor
                config.baseBackgroundColor = commonBackgroundColor
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var modified = incoming
                    modified.font = commonFont
                    return modified
                }
                button.configuration = config
            } else {
                button.backgroundColor = commonBackgroundColor
                button.titleLabel?.font = commonFont
                button.setTitle(title, for: .normal)
                button.setTitleColor(commonForegroundColor, for: .normal)
                button.layer.cornerRadius = 8
            }
            
            return button
        }
        
        // 各スタイルのボタンを作成
        let plainButton = createButton(configuration: .plain(), title: "Plain")
        let grayButton = createButton(configuration: .gray(), title: "Gray")
        let tintedButton = createButton(configuration: .tinted(), title: "Tinted")
        let filledButton = createButton(configuration: .filled(), title: "Filled")
        let borderedButton = createButton(configuration: .bordered(), title: "Bordered")
        let borderedTintedButton = createButton(configuration: .borderedTinted(), title: "Bordered Tinted")
        let borderedProminentButton = createButton(configuration: .borderedProminent(), title: "Bordered Prominent")

        // ボタンを縦に並べる
        let stackView = UIStackView(
            arrangedSubviews: [
                plainButton,
                grayButton,
                tintedButton,
                filledButton,
                borderedButton,
                borderedTintedButton,
                borderedProminentButton
            ],
            axis: .vertical,
            spacing: 8,
            alignment: .fill
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    return UIViewWrapper(view: stackView)
        .frame(width: 300, height: 500)
        .padding()
}

#Preview("ImageOnlyPlainButton", traits: .sizeThatFitsLayout) {
    let imageOnlyButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.image = UIImage(systemName: "star.fill")
        button.configuration?.baseForegroundColor = .systemRed // アイコンの色
        button.configuration?.cornerStyle = .capsule // 丸みを付ける場合
        button.frame.size = CGSize(width: 60, height: 60) // サイズを指定
        return button
    }()

    return UIViewWrapper(view: imageOnlyButton)
        .frame(width: 80, height: 80)
        .padding()
}
