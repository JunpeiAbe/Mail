import UIKit
import SwiftUI

extension UICollectionView {
    /// `UICollectionView` の簡易初期化
    /// - Parameters:
    ///   - layout: `UICollectionViewLayout` を指定。コレクションビューのレイアウトを決定する必須パラメータ。
    ///   - showsVerticalScrollIndicator: 垂直スクロールインジケーターを表示するかどうか。デフォルトは `true`。
    ///   - showsHorizontalScrollIndicator: 水平スクロールインジケーターを表示するかどうか。デフォルトは `false`。
    ///   - backgroundColor: コレクションビューの背景色を設定。デフォルトは白色 (`.white`)。
    ///   - contentInset: コレクションビューのコンテンツに適用する余白を設定。デフォルトは `.zero`。
    ///   - allowsSelection: セルの選択を許可するかどうかを設定。デフォルトは `true`。
    ///   - allowsMultipleSelection: セルの複数選択を許可するかどうかを設定。デフォルトは `false`。
    convenience init(
        layout: UICollectionViewLayout, // コレクションビューのレイアウトを指定
        showsVerticalScrollIndicator: Bool = true, // 垂直スクロールインジケーターの表示設定
        showsHorizontalScrollIndicator: Bool = false, // 水平スクロールインジケーターの表示設定
        backgroundColor: UIColor = .white, // 背景色を指定
        contentInset: UIEdgeInsets = .zero, // コンテンツの余白を指定
        allowsSelection: Bool = true, // セル選択の許可設定
        allowsMultipleSelection: Bool = false // セルの複数選択を許可するかどうかを指定
    ) {
        self.init(frame: .zero, collectionViewLayout: layout) // レイアウトを適用して初期化
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator // 垂直スクロールインジケーター設定
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator // 水平スクロールインジケーター設定
        self.backgroundColor = backgroundColor // 背景色を設定
        self.contentInset = contentInset // コンテンツの余白を設定
        self.allowsSelection = allowsSelection // セル選択を許可するか設定
        self.allowsMultipleSelection = allowsMultipleSelection // 複数選択を許可するか設定
    }
    
    /// セルの登録
    func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
    
    /// セルの再利用
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }
}
