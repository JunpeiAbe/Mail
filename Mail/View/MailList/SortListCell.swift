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
    
    // 初期化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [sortKindNameLabel],
            axis: .vertical,
            distribution: .fill,
            alignment: .center
        )
        self.addSubview(mainStackView)
        mainStackView
            .anchor(
                top: self.topAnchor,
                left: self.leadingAnchor,
                bottom: self.bottomAnchor,
                right: self.trailingAnchor
            )
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        sortKindNameLabel.text = viewModel.sortKind.rawValue
        sortKindNameLabel.textColor = viewModel.isChecked ? .white : .black
        self.backgroundColor = viewModel.isChecked ? .systemBlue : .clear
        self.layer.borderColor = viewModel.isChecked ? UIColor.clear.cgColor : UIColor.black.cgColor
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
        .frame(width: .infinity,height: 44)
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
        .frame(width: .infinity,height: 44)
}
