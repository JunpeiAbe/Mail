import UIKit
import SwiftUI

/// メールリストのセル
final class MailListCell: UITableViewCell {
    
    /// セルビューモデル
    var viewModel: MailListCellViewModel? {
        didSet {
            configure()
        }
    }
    
    /// メールの送信者ラベル
    private let senderLabel: UILabel = {
        let label: UILabel = .init(
            font: .systemFont(ofSize: 18, weight: .bold)
        )
        return label
    }()
    /// メールの件名ラベル
    private let subjectLabel: UILabel = {
        let label: UILabel = .init(
            font: .systemFont(ofSize: 16, weight: .regular)
        )
        return label
    }()
    /// メールの本文ラベル
    private let bodyLabel: UILabel = {
        let label: UILabel = .init(
            font: .systemFont(ofSize: 16, weight: .regular),
            textColor: .secondaryLabel,
            numberOfLines: 2
        )
        return label
    }()
    /// 受信日時ラベル
    private let timestampLabel: UILabel = {
        let label: UILabel = .init(
            font: .systemFont(ofSize: 16, weight: .regular),
            textColor: .secondaryLabel
        )
        return label
    }()
    /// 矢印イメージ
    private let arrorImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = .rightArrow
        return image
    }()
    /// 未読イメージ
    private let unreadImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = .unreadCircle
        return image
    }()
    /// 既読イメージ
    private let readImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = .readCircle
        return image
    }()
    /// ディバイダーイメージ
    private let dividerImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = .divider
        return image
    }()
    
    // 初期化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        senderLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        senderLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        subjectLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        subjectLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        bodyLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        // メインの親スタックビューを作成
        let mainStackView = UIStackView(
            arrangedSubviews: [senderLabel, subjectLabel, bodyLabel],
            axis: .vertical,
            spacing: 4, // 垂直方向の間隔
            distribution: .fill,
            alignment: .fill
        )
        let leftSideStackView = UIStackView(
            arrangedSubviews: [unreadImage],
            axis: .horizontal,
            distribution: .fill,
            alignment: .top
        )
        // 他のコンポーネントを配置するためのビュー
        let rightSideStackView = UIStackView(
            arrangedSubviews: [timestampLabel, arrorImage],
            axis: .horizontal,
            spacing: 4,
            distribution: .fill,
            alignment: .top
        )
        mainStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        mainStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        rightSideStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightSideStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // メインレイアウト（左右の配置）
        let overallStackView = UIStackView(
            arrangedSubviews: [leftSideStackView, mainStackView, rightSideStackView],
            axis: .horizontal,
            spacing: 10,
            distribution: .fill,
            alignment: .fill
        )
        
        let dividerStackview = UIStackView(
            arrangedSubviews: [
                dividerImage
            ],
            axis: .vertical,
            distribution: .fill,
            alignment: .fill
        )
        
        let addDividerStackView = UIStackView(
            arrangedSubviews: [
                overallStackView,
                dividerStackview
            ],
            axis: .vertical,
            spacing: 8,
            directionalLayoutMargins: .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        )
        
        // overallStackViewをコンテンツビューに追加
        contentView.addSubview(addDividerStackView)
        
        // 制約を設定
        addDividerStackView.anchor(
            top: contentView.topAnchor,
            left: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.trailingAnchor
        )
        
        unreadImage.anchor(
            width: 16,
            height: 16
        )
        
        arrorImage.anchor(
            width: 16,
            height: 16
        )
        
        dividerImage.anchor(height: 0.5)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        senderLabel.text = viewModel.sender
        subjectLabel.text = viewModel.subject
        bodyLabel.text = viewModel.body
        timestampLabel.text = viewModel.timestamp
    }
}


//struct MailListCellPreview_Previews: PreviewProvider {
//    /// - note: previewsはstaticなプロパティとして定義されているため、インスタンスの変数や状態を保持できない→view生成後のプロパティ変更ができない→クロージャ内部でviewModelをセット
//    ///  また、Viewはstructを基盤としているため、イミュータブルな設計になっている→Viewの中でプロパティ変更ができない
//    static var previews: some View {
//        let viewModel: MailListCellViewModel = .init(
//            mail: Mail(
//                id: UUID(),
//                sender: "送信者",
//                recipient: "受信者",
//                subject: "件名",
//                body: "本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文",
//                isRead: false,
//                timestamp: Date.now
//            )
//        )
//        let view: MailListCell = {
//            let view: MailListCell = .init(style: .default, reuseIdentifier: nil)
//            view.viewModel = viewModel
//            return view
//        }()
//        UIViewWrapper(view: view)
//            .frame(width: .infinity,height: 150)
//            .previewLayout(.sizeThatFits)
//    }
//}

#Preview(traits: .sizeThatFitsLayout) {
    let viewModel: MailListCellViewModel = .init(
        mail: Mail(
            id: UUID(),
            sender: "送信者",
            recipient: "受信者",
            subject: "件名",
            body: "本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文",
            isRead: false,
            timestamp: Date.now
        )
    )
    let view: MailListCell = {
        let view: MailListCell = .init(style: .default, reuseIdentifier: nil)
        view.viewModel = viewModel
        return view
    }()
    UIViewWrapper(view: view)
        .frame(width: .infinity,height: 150)
}

