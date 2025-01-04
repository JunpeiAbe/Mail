import UIKit
import SwiftUI
/// アイコン画像リスト表示画面
final class IconListViewController: UIViewController {
    // 表示用アイテム
    struct Item {
        let image: UIImage
        let title: String
    }
    
    private let items: [Item] = [
        .init(image: .heart, title: "Heart"),
        .init(image: .bell, title: "Bell"),
        .init(image: .bolt, title: "Bolt"),
        .init(image: .paperplane, title: "Paperplane")
    ]
    
    private let collectionView: IconCollectionView = {
        let collectionView: IconCollectionView = .init()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [collectionView],
            axis: .vertical
        )
        view.addSubview(mainStackView)
        mainStackView.anchor(
            top: view.topAnchor,
            left: view.leadingAnchor,
            bottom: view.bottomAnchor,
            right: view.trailingAnchor
        )
    }
}

// - MARK: UICollectionViewDelegate
extension IconListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped:\(indexPath.row)")
    }
}

// - MARK: UICollectionViewDataSource
extension IconListViewController: UICollectionViewDataSource {
    // セルの数を指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    // セルの作成
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(IconCollectionCell.self, for: indexPath)
        cell.configure(image: items[indexPath.row].image, title: items[indexPath.row].title)
        return cell
    }
}

// - MARK: UICollectionViewDelegateFlowLayout
extension IconListViewController: UICollectionViewDelegateFlowLayout {
    // セル同士の行間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    // セル同士の列間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    // セルとコレクションビュー本体の余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 画面サイズ
        let viewSize: CGSize = view.frame.size
        // セル同士の列間隔(横)
        let cellSpacng: CGFloat = 8
        // 表示したいセルの数
        let cellCount: CGFloat = 3
        // セルの表示スペース(余白を除く)
        let contentSpace: CGFloat = viewSize.width - (cellSpacng * (cellCount - 1 )) - 32
        // セルサイズ(正方形に表示したいので高さと幅に同じ値を指定)
        let cellSize: CGSize = .init(
            width: contentSpace/cellCount,
            height: contentSpace/cellCount
        )
        return cellSize
    }
}

#Preview {
    let viewController: IconListViewController = .init()
    UIViewControllerWrapper(viewController: viewController)
}
