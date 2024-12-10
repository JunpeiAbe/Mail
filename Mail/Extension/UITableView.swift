import UIKit

extension UITableView {
    /// セルを登録する
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    /// セルを再利用する
    func dequeReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error: Could not dequeue cell with identifier \(identifier)")
        }
        return cell
    }
    /// ヘッダーまたはフッターを登録する
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        let identifier = String(describing: viewType)
        self.register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
    }
    /// ヘッダーまたはフッターを再利用する
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T? {
        let identifier = String(describing: T.self)
        return self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T
    }
    /// メインスレッドでリロード
    @MainActor
    func reload() {
        self.reloadData()
    }
    /// セルの高さを自動調整
    func enableAutomaticDimension(rowHeight: CGFloat = UITableView.automaticDimension) {
        self.estimatedRowHeight = rowHeight
        self.rowHeight = UITableView.automaticDimension
    }
    /// 最初の行にスクロール
    @MainActor
    func scrollToTop(animated: Bool = true) {
        let indexPath = IndexPath(row: 0, section: 0)
        if self.numberOfSections > 0,
           self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
