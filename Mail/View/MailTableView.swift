import UIKit

/// メールリストのテーブルビュー
final class MailTableView: UITableView {
    
    /// - note: データ配列をCellViewModelとして保持
    var viewModels: [MailListCellViewModel] = [] {
        didSet {
            reload()
        }
    }
    
    private init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // デリゲートとデータソースを設定
        dataSource = self
        delegate = self
        // セルの登録
        registerCell(MailListCell.self)
    }
}

extension MailTableView: UITableViewDelegate {
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected:\(indexPath.row)")
    }
}

extension MailTableView: UITableViewDataSource {
    // セルの要素を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    // セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeReusableCell(MailListCell.self, for: indexPath)
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    // セルの高さを指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
