import UIKit

extension UIStackView {
    /// 複数のarrangementSubViewsを追加するメソッド
    func addArrangementSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
    /// プロパティを簡易に設定できるイニシャライザ
    convenience init(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}
