import UIKit
import SwiftUI
// ソート選択モーダルのコンテンツ
final class SortListModalContent: UIView {
    
    var cancelButtonAction: (() -> Void)?
    var doneButtonAction: (() -> Void)?
    
    // セルビューモデルのリスト(選択状態:isCheckedを保持)
    var cellViewModels: [SortListCellViewModel] = [
        .init(sortKind: .dateAscending),
        .init(sortKind: .dateDescending),
        .init(sortKind: .senderAscending),
        .init(sortKind: .senderDescending),
        .init(sortKind: .subjectAscending),
        .init(sortKind: .subjectDescending),
        .init(sortKind: .unreadFirst)
    ]
    // セルビューモデルリストの選択状態のもの
    var currentOption: SortListCellViewModel? {
        cellViewModels.first { $0.isChecked }
    }
    
    /// 選択項目リスト
    let tableView: UITableView = {
        let tableView: UITableView = .init()
        return tableView
    }()
    
    /// キャンセルボタン
    let cancelButton: CommonButton = {
        let button: CommonButton = .init(
            title: "Cancel",
            titleColor: .black,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            borderWidth: 1,
            borderColor: .black,
            normalColor: .white,
            highlightedColor: .white.withAlphaComponent(0.8)
        )
        return button
    }()
    
    /// 完了ボタン
    let doneButton: CommonButton = {
        let button: CommonButton = .init(
            title: "OK",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .systemBlue,
            highlightedColor: .systemBlue.withAlphaComponent(0.8)
        )
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(SortListCell.self)
        tableView.separatorStyle = .none
    }
    
    func layout() {
        let buttonsStackView: UIStackView = .init(
            arrangedSubviews: [cancelButton, doneButton],
            axis: .horizontal,
            spacing: 8,
            distribution: .fillEqually,
            alignment: .bottom
        )
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [tableView,buttonsStackView],
            axis: .vertical,
            spacing: 16
        )
        self.addSubview(mainStackView)
        
        mainStackView.anchor(
            top: self.topAnchor,
            left: self.leadingAnchor,
            bottom: self.bottomAnchor,
            right: self.trailingAnchor
        )
        cancelButton.anchor(height: 44)
        doneButton.anchor(height: 44)
    }
    
    @objc func cancelButtonTapped() {
        cancelButtonAction?()
    }
    
    @objc func doneButtonTapped() {
        doneButtonAction?()
    }
}

// - MARK: UITableViewDelegete
extension SortListModalContent: UITableViewDelegate {
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 現在の選択肢と新たに選択したセルの選択肢が一致した場合
        if let currentOption,
           currentOption.sortKind == cellViewModels[indexPath.row].sortKind
        {
            // 処理を終了
            return
        } else {
            // 全てを未選択に変更
            cellViewModels.forEach {
                $0.isChecked = false
            }
            cellViewModels[indexPath.row].isChecked = true
        }
        // セルのレイアウトを更新
        tableView.reloadData()
        print("cell selected:\(indexPath.row)")
    }
}
// - MARK: UITableViewDatasource
extension SortListModalContent: UITableViewDataSource {
    // セルの要素を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    // セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(SortListCell.self, for: indexPath)
        // cellViewModelをセット
        cell.viewModel = cellViewModels[indexPath.row]
        return cell
    }
    // セルの高さを指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let view: SortListModalContent = {
        let view: SortListModalContent = .init(frame: .zero)
        return view
    }()
    UIViewWrapper(view: view)
        .padding()
}
