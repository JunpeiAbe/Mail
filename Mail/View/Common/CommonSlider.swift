import UIKit
import SwiftUI
/// 共通スライダー
final class CommonSlider: UISlider {
    
    private let thumbLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    var valueChangedHandler: ((Float) -> Void)? // 値変更時に呼び出すクロージャ
    
    init(
        thumbImage: UIImage? = nil,
        minimumTrackImage: UIImage? = nil,
        maximumTrackImage: UIImage? = nil,
        minimumValue: Float = 0,
        maximumValue: Float = 100,
        initialValue: Float = 50
    ) {
        super.init(frame: .zero)
        setup(
            thumbImage: thumbImage,
            minimumTrackImage: minimumTrackImage,
            maximumTrackImage: maximumTrackImage,
            minimumValue: minimumValue,
            maximumValue: maximumValue,
            initialValue: initialValue
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(
        thumbImage: UIImage? = nil,
        minimumTrackImage: UIImage? = nil,
        maximumTrackImage: UIImage? = nil,
        minimumValue: Float = 0,
        maximumValue: Float = 100,
        initialValue: Float = 50
    ) {
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
        
        if let minimumTrackImage = minimumTrackImage {
            self.setMinimumTrackImage(minimumTrackImage.resizableImage(withCapInsets: .zero), for: .normal)
        }
        
        if let maximumTrackImage = maximumTrackImage {
            self.setMaximumTrackImage(maximumTrackImage.resizableImage(withCapInsets: .zero), for: .normal)
        }
        
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.value = initialValue
        
        // ラベルを追加
        self.addSubview(thumbLabel)
        updateThumbLabel()
        // 値変更時のイベント
        addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    /// 値変更時
    @objc private func sliderValueChanged() {
        updateThumbLabel()
        updateLabelPosition()
        valueChangedHandler?(value) // クロージャで値を通知
    }
    
    private func updateThumbLabel() {
        thumbLabel.text = String(format: "%.0f", value)
    }
    
    private func updateLabelPosition() {
        // トラックとつまみの位置を取得
        let trackRect = self.trackRect(forBounds: self.bounds)
        let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: self.value)
        // ラベルのサイズをつまみ画像と一致させる
        thumbLabel.frame.size = thumbRect.size
        // ラベルの位置をつまみの中心に設定
        let thumbCenterX = thumbRect.origin.x + thumbRect.width / 2
        let thumbCenterY = thumbRect.origin.y + thumbRect.height / 2
        thumbLabel.center = CGPoint(x: thumbCenterX, y: thumbCenterY)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 初期レイアウト後に位置を更新
        /// - note: layoutSubviewsで位置を決めないと、初期位置がずれてしまう
        updateLabelPosition()
    }
}

#Preview("Custom Slider", traits: .sizeThatFitsLayout) {
    let slider = CommonSlider(
        thumbImage: .largerSliderThumb
    )
    
    return UIViewWrapper(view: slider)
        .frame(height: 60)
        .padding()
}
