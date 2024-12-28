import UIKit

/// メールリストのテーブルビュー
final class MailListTableView: UITableView {

    /// pull to refresh closure
    var onRefresh: (() -> Void)?
    
    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // セルの登録
        registerCell(MailListCell.self)
        // リフレッシュコントロールの登録
        addRefreshControl(target: self, action: #selector(handleRefresh))
    }
    @objc func handleRefresh() {
        onRefresh?()
    }
    /// リフレッシュの終了
    func finishRefresh() {
        endRefreshing()
    }
}
