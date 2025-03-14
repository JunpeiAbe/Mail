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
    
    /// 削除ボタン
    lazy var deleteButton: UIBarButtonItem = {
        let item: UIBarButtonItem = .init(
            title: "削除",
            style: .plain,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        return item
    }()

    /// 編集ボタン
    lazy var editButton: UIBarButtonItem = {
        let item: UIBarButtonItem = .init(
            title: "編集",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        return item
    }()

    /// フィルターボタン
    lazy var filterButton: UIBarButtonItem = {
        let item: UIBarButtonItem = .init(
            image: .filterButton,
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        return item
    }()
    
    let sortListModalContent: SortListModalContent = {
        let content: SortListModalContent = .init()
        content.cellViewModels.first?.isChecked = true
        return content
    }()
    /// 前回のソート選択項目
    var lastSortKind: SortKind?
    
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
        tableView.allowsSelectionDuringEditing = true // 編集モード時の選択を有効化
        // 初回読み込み
        loadingIndicator.startAnimating()
        viewModel.firstLoad()
        // pull to reflesh
        tableView.onRefresh = { [weak self] in
            if let self,
               self.tableView.isEditing {
                // 編集状態の場合はリフレッシュせず、即時終了させる
                tableView.endRefreshing()
                return
            }
            self?.viewModel.refresh()
        }
        // viewModelのデータ更新
        viewModel.onDataUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.finishRefresh()
            self?.loadingIndicator.stopAnimating()
        }
        // ソートモーダルのキャンセルボタンタップ時
        sortListModalContent.cancelButtonAction = { [weak self] in
            guard let self = self else { return }
            // 前回の選択項目が空でない場合(doneタップして適用済みの場合)
            // 遷移前の値に戻す
            sortListModalContent.cellViewModels.forEach {
                if $0.sortKind == self.lastSortKind {
                    $0.isChecked = true
                } else {
                    $0.isChecked = false
                }
            }
            // モーダルを閉じる
            self.dismiss(animated: true)
        }
        // ソートモーダルのdoneボタンタップ時
        sortListModalContent.doneButtonAction = { [weak self] cellViewModels in
            guard let self = self else { return }
            lastSortKind = cellViewModels.filter { $0.isChecked }.first?.sortKind
            // モーダルを閉じる
            self.dismiss(animated: true)
            // - TODO: ソートを適用する
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
        navigationItem.leftBarButtonItems = [filterButton, deleteButton]
        deleteButton.isHidden = !tableView.isEditing
        navigationItem.rightBarButtonItems = [editButton]
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
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.title = tableView.isEditing ? "キャンセル" : "編集"
        deleteButton.isHidden = !tableView.isEditing
        // 編集状態の際にボタンタップでチェック状態を初期化
        if tableView.isEditing {
            viewModel.cellViewModels.forEach {
                $0.isChecked = false
            }
        }
        // 編集状態で現在表示しているセルに空のチェックマークを表示
        viewModel.cellViewModels.forEach {
            $0.isEditing = tableView.isEditing
        }
        tableView.reload()
    }
    @objc private func deleteButtonTapped() {
        viewModel.removeCheckedMail()
    }
    // - TODO: sortListModalContentの高さを内部コンテンツの高さによって決定したい
    @objc private func filterButtonTapped() {
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        modalViewController.contentView = sortListModalContent
        // 遷移前のSortを保持
        lastSortKind = sortListModalContent.cellViewModels.filter { $0.isChecked }.first?.sortKind
        present(modalViewController, animated: true)
    }
}
    
// MARK: UITableViewDelegate
extension MailListViewController: UITableViewDelegate {
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // チェック状態の更新(編集状態でのみ更新)
        if tableView.isEditing {
            viewModel.cellViewModels[indexPath.row].isChecked.toggle()
        } else {
            // 未読→既読へ更新(編集状態でない場合のみ)
            viewModel.cellViewModels[indexPath.row].mail.isRead = true
        }
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
    // 編集状態での左側のアイコン表示(defaultはdelete)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    // 編集状態での左側の余白追加をするかどうか(defaultはtrue)
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
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

// MARK: UIViewControllerTransitioningDelegate
extension MailListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: Preview
#Preview(traits: .sizeThatFitsLayout) {
    let viewController = MailListViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    UIViewControllerWrapper(viewController: navigationController)
}

