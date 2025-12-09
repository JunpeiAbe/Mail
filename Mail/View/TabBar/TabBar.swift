import UIKit
import SwiftUI
/// カスタムタブバー
final class TabBar: UIView {
    
    struct TabItem {
        let icon: UIImage?
        let title: String
    }
    
    init(
        tabItems: [TabItem]
    ) {
        super.init(frame: .zero)
        setup(tabItems)
    }
    
    private func setup(_ items: [TabItem]) {
        let tabStackView: UIStackView = .init(
            arrangedSubviews: [],
            axis: .horizontal,
            spacing: 8
        )
        items.forEach { item in
            let imageView: UIImageView = {
                let image: UIImageView = .init(image: item.icon)
                image.frame = .init(origin: .zero, size: .init(width: 12, height: 12))
                return image
            }()
            let titleLabel: UILabel = {
                let label: UILabel = .init(
                    text: item.title,
                    font: .systemFont(ofSize: 8)
                )
                return label
            }()
            let itemStackView: UIStackView = .init(
                arrangedSubviews: [imageView, titleLabel],
                axis: .vertical,
                spacing: 4,
                directionalLayoutMargins: .init(
                    top: 8,
                    leading: 8,
                    bottom: 8,
                    trailing: 8
                )
            )
            self.addSubview(tabStackView)
            tabStackView.addArrangedSubview(itemStackView)
            tabStackView.anchor(
                top: self.topAnchor,
                left: self.leadingAnchor,
                bottom: self.bottomAnchor,
                right: self.trailingAnchor
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("TabBar", traits: .sizeThatFitsLayout) {
    let tabBar: TabBar = {
        let tabBar = TabBar(
            tabItems: [
                .init(icon: .init(systemName: "house.fill"), title: "ホーム"),
                .init(icon: .init(systemName: "magnifyingglass"), title: "検索"),
                .init(icon: .init(systemName: "person.fill"), title: "プロフィール")
            ]
        )
        return tabBar
    }()
    UIViewWrapper(view: tabBar)
        .frame(height: 60)
        .padding()
}
