import UIKit
import SwiftUI

/// メールリスト一覧画面
final class MailListViewController: UIViewController {
    
    let tableView: MailListTableView = {
        let tableView: MailListTableView = .init()
        return tableView
    }()
    
    let viewModel = MailListControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        // 初回読み込み
        viewModel.firstLoad()
        // pull to reflesh
        tableView.onRefresh = { [weak self] in
            self?.viewModel.firstLoad()
        }
        // viewModelのデータ更新
        viewModel.onDataUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.finishRefresh()
        }
    }
    
    private func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [tableView],
            axis: .horizontal
        )
        tableView.backgroundColor = .blue
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.topAnchor,left: view.leadingAnchor,bottom: view.bottomAnchor, right: view.trailingAnchor)
    }
}
    
// MARK: UITableViewDelegate
extension MailListViewController: UITableViewDelegate {
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected:\(indexPath.row)")
    }
    // 任意のセルが表示された場合
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // データの追加読み込み
        print("cell load more")
        viewModel.moreLoad()
    }
}

// MARK: UITableViewDataSource
extension MailListViewController: UITableViewDataSource {
    // セルの要素を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    // セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(MailListCell.self, for: indexPath)
        cell.viewModel = viewModel.cellViewModels[indexPath.row]
        return cell
    }
    // セルの高さを指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Preview
#Preview(traits: .sizeThatFitsLayout) {
    let viewController = MailListViewController()
    UIViewControllerWrapper(viewController: viewController)
}

