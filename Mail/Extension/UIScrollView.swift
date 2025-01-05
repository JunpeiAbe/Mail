import UIKit
import SwiftUI
/// スクロールビューの拡張
/// - note: frameLayoutGuide: scrollView.frameLayoutGuide の範囲は、画面に見えるスクロールビューの範囲（例えば、画面上でスクロールバーが表示される領域）
/// - note: contentLayoutGuide: scrollView.contentLayoutGuide の範囲は、contentView によって決まる全体の範囲（例えば、1200px の高さ）です。この範囲が frameLayoutGuide より大きければスクロール可能になる。
extension UIScrollView {
    /// UIScrollView の簡易初期化
    convenience init(
        isPagingEnabled: Bool = false,
        showsVerticalScrollIndicator: Bool = true,
        showsHorizontalScrollIndicator: Bool = true,
        bounces: Bool = true,
        alwaysBounceVertical: Bool = false,
        alwaysBounceHorizontal: Bool = false,
        isDirectionalLockEnabled: Bool = false, // スクロール方向をロックする
        contentInset: UIEdgeInsets = .zero
    ) {
        self.init(frame: .zero)
        self.isPagingEnabled = isPagingEnabled
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self.bounces = bounces
        self.alwaysBounceVertical = alwaysBounceVertical
        self.alwaysBounceHorizontal = alwaysBounceHorizontal
        self.isDirectionalLockEnabled = isDirectionalLockEnabled
        self.contentInset = contentInset
    }
    
    /// コンテンツサイズを更新する
    /// - Parameters:
    ///   - width: コンテンツ幅 (nilの場合は変更しない)
    ///   - height: コンテンツ高さ (nilの場合は変更しない)
    func updateContentSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        var newSize = self.contentSize
        if let width = width {
            newSize.width = width
        }
        if let height = height {
            newSize.height = height
        }
        self.contentSize = newSize
    }
}

#Preview {
    final class PreviewController: UIViewController {
        
        private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            return scrollView
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            layout()
        }
        
        func layout() {
            let view: UIView = .init()
            view.backgroundColor = .red
            let view2: UIView = .init()
            view2.backgroundColor = .green
            let view3: UIView = .init()
            view3.backgroundColor = .blue
            
            let mainStackView: UIStackView = .init(
                arrangedSubviews: [scrollView],
                axis: .vertical,
                directionalLayoutMargins: .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            )
            
            let contentStackView: UIStackView = .init(
                arrangedSubviews: [
                    view,
                    view2,
                    view3
                ],
                axis: .vertical,
                directionalLayoutMargins: .init(top: 16, leading: 32, bottom: 16, trailing: 32)
            )
            contentStackView.backgroundColor = .yellow
            self.view.addSubview(mainStackView)
            scrollView.addSubview(contentStackView)
            scrollView.backgroundColor = .brown
            mainStackView.anchor(
                top: self.view.topAnchor,
                left: self.view.leadingAnchor,
                bottom: self.view.bottomAnchor,
                right: self.view.trailingAnchor
            )
            
            view.anchor(height: 300)
            view2.anchor(height: 400)
            view3.anchor(height: 500)
            // 下記の設定はデフォルト
            // contentInsetや以下でcontentStackViewに余白をつけるとスクロール範囲がおかしくなるので以下で良い
            // コンテンツの制約をcontentLayoutGuideにつける
            contentStackView.anchor(
                top: scrollView.contentLayoutGuide.topAnchor,
                left: scrollView.contentLayoutGuide.leadingAnchor,
                bottom: scrollView.contentLayoutGuide.bottomAnchor,
                right: scrollView.contentLayoutGuide.trailingAnchor
            )
            // コンテンツの横幅の制約をframeLayoutGuideにつける
            contentStackView.sizeAnchor(width: scrollView.frameLayoutGuide.widthAnchor)
        }
    }
    let viewController: PreviewController = .init()
    return UIViewControllerWrapper(viewController: viewController)
}
