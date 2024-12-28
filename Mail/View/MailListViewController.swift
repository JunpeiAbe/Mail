import UIKit
import SwiftUI

/// メールリスト一覧画面
final class MailListViewController: UIViewController {
    
    let tableView: MailListTableView = {
        let tableView: MailListTableView = .init()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        // pull to reflesh
        tableView.onRefresh = { [weak self] in
            // - TODO: viewModelに定義したリロード処理を行う
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
}

// MARK: UITableViewDataSource
extension MailListViewController: UITableViewDataSource {
    // セルの要素を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // - TODO: viewModelに定義したリストに差し替える
        return 0
    }
    // セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(MailListCell.self, for: indexPath)
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

