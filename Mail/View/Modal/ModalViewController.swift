import Foundation
import UIKit
import SwiftUI
/// モーダル
/// - UIPresentationController：遷移アニメーションと画面上のビューコントローラーの表示を管理するクラス
final class ModalViewController: UIViewController {
    /// 内部のコンテンツ
    var contentView: UIView?
    
    /// モーダルのシート
    let modalSheetView: UIView = {
        let view: UIView = .init()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupContentView()
    }
    
    private func setupContentView() {
        guard let contentView = contentView else { return }
        modalSheetView.addSubview(contentView)
        /// - note: isLayoutMarginsRelativeArrangementをfalseにしないとなぜかmodalSheetViewがsafearea内部に表示されてしまう(バグっぽい)
        /// - note: extensionのデフォルト設定でisLayoutMarginsRelativeArrangement = trueとしていた
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [modalSheetView],
            axis: .horizontal,
            isLayoutMarginsRelativeArrangement: false,
            distribution: .fill,
            alignment: .bottom
        )
        view.addSubview(mainStackView)
        
        modalSheetView.anchor(height: contentView.frame.height)
        modalSheetView.frame.size = CGSize(width: view.frame.width, height: contentView.frame.height)
        
        contentView.anchor(
            top: modalSheetView.topAnchor,
            left: modalSheetView.leadingAnchor,
            bottom: modalSheetView.bottomAnchor,
            right: modalSheetView.trailingAnchor
        )
        mainStackView.anchor(
            top: view.topAnchor,
            left: view.leadingAnchor,
            bottom: view.bottomAnchor,
            right: view.trailingAnchor
        )
        /// - note: 背景タップをモーダル部分以外の部分に適用する
        // モーダルシート以外の領域をカバーする透明なビューを追加
        let overlayView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: view.frame.height - modalSheetView.frame.height
        ))
        overlayView.backgroundColor = .clear // 完全透明
        overlayView.isUserInteractionEnabled = true
        
        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        view.addSubview(overlayView) // 透明なビューを `view` の上に配置
    }
    
    // overlayViewをタップした時に呼ばれる
    @objc private func overlayTapped(_ sender: UITapGestureRecognizer) {
        print("Overlay tapped")
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Preview
#Preview(traits: .sizeThatFitsLayout) {
    var content: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        return view
    }()
    
    let viewController: ModalViewController = {
        let viewController: ModalViewController = .init()
        viewController.contentView = content
        return viewController
    }()
    
    UIViewControllerWrapper(viewController: viewController)
}
