import UIKit
import SwiftUI

/// アイコンリストのセル
final class IconCollectionCell: UICollectionViewCell {
    
    /// アイコンイメージ
    private var iconImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = .paperplane
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    /// アイコンタイトルラベル
    private let titleLabel: UILabel = {
        let label: UILabel = .init(
            font: .systemFont(ofSize: 16, weight: .bold)
        )
        return label
    }()
    
    // 初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [
                iconImage,
                titleLabel
            ],
            axis: .vertical,
            spacing: 16,
            directionalLayoutMargins: .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            alignment: .center
        )
        /// - note: StackViewには影は適用できないため、stackVewの外側のcontentViewに対して影を適用する
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .init(width: 0, height: 8)
        contentView.layer.shadowRadius = 8
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 0.2
        contentView.backgroundColor = .white
        contentView.addSubview(mainStackView)
        
        iconImage.anchor(width: 60, height: 60)
        mainStackView.anchor(
            top: contentView.topAnchor,
            left: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.trailingAnchor
        )
    }
    
    func configure(image: UIImage, title: String) {
        titleLabel.text = title
        iconImage.image = image
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let view: IconCollectionCell = {
        let view: IconCollectionCell = .init()
        view.configure(image: .paperplane, title: "paperplane")
        return view
    }()
    
    UIViewWrapper(view: view)
        .frame(width: 150, height: 150)
        .padding()
}
