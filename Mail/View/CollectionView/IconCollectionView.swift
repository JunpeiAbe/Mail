import UIKit
import SwiftUI
/// アイコンリストのコレクションビュー
final class IconCollectionView: UICollectionView {
    
    init() {
        let layout: UICollectionViewFlowLayout = .init()
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // セルの登録
        self.registerCell(IconCollectionCell.self)
        // レイアウトの設定
    }
}
