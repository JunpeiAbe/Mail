import UIKit
import SwiftUI
/// ユーザーセル
final class UserCell: UITableViewCell {
    /// アイコン画像
    private let iconImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = .init(systemName: "person.circle")
        image.contentMode = .scaleAspectFit
        return image
    }()
    /// 名前ラベル
    private let nameLabel: UILabel = {
        let label: UILabel = .init(
            text: "name",
            font: .systemFont(ofSize: 18, weight: .bold)
        )
        return label
    }()
    
    // 初期化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let horizontalStackView: UIStackView = .init(
            arrangedSubviews: [
                iconImageView,
                nameLabel
            ],
            axis: .horizontal,
            spacing: 8
        )
        let verticalStackView: UIStackView = .init(
            arrangedSubviews: [horizontalStackView],
            axis: .vertical
        )
        contentView.addSubview(verticalStackView)
        
        verticalStackView
            .anchor(
                top: contentView.topAnchor,
                left: contentView.leadingAnchor,
                bottom: contentView.bottomAnchor,
                right: contentView.trailingAnchor
            )
        iconImageView.anchor(width: 48, height: 48)
    }
    
    func configure(user: SearchedUser) {
        
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    let view: UserCell = {
        let view: UserCell = .init(style: .default, reuseIdentifier: nil)
        view.configure(user: .init(id: UUID(), name: "JohnDoe"))
        return view
    }()
    UIViewWrapper(view: view)
        .frame(width: .infinity,height: 80)
}

