import UIKit
import SwiftUI
/// アイコン画像リスト表示画面
final class IconListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// - MARK: UICollectionViewDelegate
extension IconListViewController: UICollectionViewDelegate {
    
}

// - MARK: UICollectionViewDataSource
extension IconListViewController: UICollectionViewDataSource {
    // セルの数を指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    // セルの作成
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
