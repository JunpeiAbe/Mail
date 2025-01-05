import UIKit

extension UIView {
    /// 他のビューに対して制約を簡単に設定するためのメソッド
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingRight: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        // Auto Layoutを有効にする
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    /// 上記のみだとScrollViewのframelayoutGuideとコンテンツに制約をつけられないため以下で付加する
    func sizeAnchor(
        width: NSLayoutDimension? = nil,
        height: NSLayoutDimension? = nil
    ) {
        if let width = width {
            self.widthAnchor.constraint(equalTo: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalTo: height).isActive = true
        }
    }
    
    /// 指定したビューに対して中央に配置する制約を設定する
    func centerInSuperview(offsetX: CGFloat = 0, offsetY: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        guard let superview = self.superview else {
            print("Superviewがありません")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // 中央揃えの制約を設定
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offsetX).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offsetY).isActive = true
        
        // サイズ制約を設定
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

