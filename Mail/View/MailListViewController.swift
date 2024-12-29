import UIKit
import SwiftUI

/// メールリスト一覧画面
final class MailListViewController: UIViewController {
    
    let tableView: MailListTableView = {
        let tableView: MailListTableView = .init()
        return tableView
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init()
        indicator.color = .lightGray
        indicator.transform = .init(scaleX: 2, y: 2)
        return indicator
    }()
    
    let viewModel = MailListControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    private func setup() {
        // navigation
        setupNavigationBar()
        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        // 初回読み込み
        loadingIndicator.startAnimating()
        viewModel.firstLoad()
        // pull to reflesh
        tableView.onRefresh = { [weak self] in
            self?.viewModel.refresh()
        }
        // viewModelのデータ更新
        viewModel.onDataUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.finishRefresh()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    private func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [tableView],
            axis: .horizontal
        )
        view.addSubview(mainStackView)
        view.addSubview(loadingIndicator)
        loadingIndicator.centerInSuperview()
        mainStackView.anchor(top: view.topAnchor,left: view.leadingAnchor,bottom: view.bottomAnchor, right: view.trailingAnchor)
    }
    
    private func setupNavigationBar() {
        title = "メールリスト"
        setNavigationBarUnderline()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "編集", style: .plain, target: self, action: #selector(editButtonTapped)
        )
    }
    
    /// ナビゲーションバーの下に線が表示されるようにする
    // TODO: 設定値の意味を調べる
    func setNavigationBarUnderline() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.compactScrollEdgeAppearance = appearance
    }
    
    @objc private func editButtonTapped() {
        print("編集ボタンがタップされました")
    }
}
    
// MARK: UITableViewDelegate
extension MailListViewController: UITableViewDelegate {
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellViewModels[indexPath.row].mail.isRead = true
        // セルのレイアウトを更新
        tableView.reloadRows(at: [indexPath], with: .fade)
        print("cell selected:\(indexPath.row)")
    }
    // 任意のセルが表示された場合
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 任意のセルが表示された時のみデータの追加読み込み
        // セルビューモデルリストの最後のデータのIDと表示したセルのIDが一致した時のみ読み込み
        guard let lastID = viewModel.cellViewModels.last?.mail.id else { return }
        let currentID = viewModel.cellViewModels[indexPath.row].mail.id
        if currentID == lastID {
            viewModel.moreLoad()
        }
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
        cell.viewModel = viewModel.cellViewModels.count > 0 ? viewModel.cellViewModels[indexPath.row] : nil
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
    let navigationController = UINavigationController(rootViewController: viewController)
    UIViewControllerWrapper(viewController: navigationController)
}

