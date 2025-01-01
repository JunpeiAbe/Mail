import UIKit
import SwiftUI

/// ソートリストのセル
final class SortListCell: UITableViewCell {
    
    /// セルビューモデル
    var viewModel: SortListCellViewModel? {
        didSet {
            configure()
        }
    }
    /// ソート種別名ラベル
    private let sortKindNameLabel: UILabel = {
        let label: UILabel = .init(
            font: .systemFont(ofSize: 16, weight: .regular)
        )
        return label
    }()
    
    /// mainのstackview
    private lazy var mainStackView: UIStackView = {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [sortKindNameLabel],
            axis: .vertical,
            directionalLayoutMargins: .init(top: 16, leading: 0, bottom: 16, trailing: 0),
            distribution: .fill,
            alignment: .center
        )
        mainStackView.layer.cornerRadius = 16
        mainStackView.layer.borderWidth = 1
        return mainStackView
    }()
    
    // 初期化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // セルの選択を無効化
        self.selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.addSubview(mainStackView)
        mainStackView
            .anchor(
                top: self.topAnchor,
                left: self.leadingAnchor,
                bottom: self.bottomAnchor,
                right: self.trailingAnchor,
                paddingBottom: 8
            )
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        sortKindNameLabel.text = viewModel.sortKind.rawValue
        sortKindNameLabel.textColor = viewModel.isChecked ? .white : .black
        mainStackView.backgroundColor = viewModel.isChecked ? .systemBlue : .clear
        mainStackView.layer.borderColor = viewModel.isChecked ? UIColor.clear.cgColor : UIColor.black.cgColor
    }
}

#Preview("Selected",traits: .sizeThatFitsLayout) {
    let viewModel: SortListCellViewModel = .init(
        sortKind: .dateAscending
        )
    let view: SortListCell = {
        let view: SortListCell = .init(style: .default, reuseIdentifier: nil)
        viewModel.isChecked = true
        
        view.viewModel = viewModel
        return view
    }()
    UIViewWrapper(view: view)
}

#Preview("Not Selected",traits: .sizeThatFitsLayout) {
    let viewModel: SortListCellViewModel = .init(
        sortKind: .dateAscending
        )
    let view: SortListCell = {
        let view: SortListCell = .init(style: .default, reuseIdentifier: nil)
        view.viewModel = viewModel
        return view
    }()
    UIViewWrapper(view: view)
}
