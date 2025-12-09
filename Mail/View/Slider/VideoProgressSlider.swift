import UIKit
import SwiftUI

class VideoProgressSlider: UISlider {
    /// スライダー(ライン)の高さ
    var lineHeight: CGFloat = 4.0
    /// マーク背景色
    var markerColor: UIColor = .lightYellow
    /// 動画の総時間（秒）
    var duration: TimeInterval = 30
    /// マークしたい秒数（例: [5, 10]）
    var markerTimes: [TimeInterval] = []

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 右側（未再生側）のトラック画像
        if let maximumImage = makeTrackImage(size: rect.size, lineColor: .lightGray) {
            setMaximumTrackImage(
                maximumImage.resizableImage(withCapInsets: .zero, resizingMode: .stretch),
                for: .normal
            )
        }
        // 左側（再生済み側）のトラック画像
        if let minimumImage = makeTrackImage(size: rect.size, lineColor: .deepBlue) {
            setMinimumTrackImage(
                minimumImage.resizableImage(withCapInsets: .zero, resizingMode: .stretch),
                for: .normal
            )
        }
        // つまみの画像
        let thumbImage: UIImage = .init(systemName: "circle.fill")!
        setThumbImage(thumbImage, for: .highlighted)
        setThumbImage(thumbImage, for: .normal)
    }
    /// 線＋マーカーを描画した UIImage を生成する
    private func makeTrackImage(size: CGSize, lineColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let height = size.height
        let width = size.width
        let centerY = height / 2
        // ベースのトラック線
        context.setLineWidth(lineHeight)
        context.setLineCap(.round)
        context.move(to: CGPoint(x: 0, y: centerY))
        context.addLine(to: CGPoint(x: width, y: centerY))
        context.setStrokeColor(lineColor.cgColor)
        context.strokePath()
        // マーカー描画
        guard duration > 0 else { return UIGraphicsGetImageFromCurrentImageContext() }
        guard !markerTimes.isEmpty else { return UIGraphicsGetImageFromCurrentImageContext() }
        // 1秒あたりの幅
        let markerWidth = width / duration
        context.setFillColor(markerColor.cgColor)
        
        for time in markerTimes {
            // 範囲外は無視
            guard time >= 0, time < duration else { continue }
            // 指定秒の区間の左端
            let originX = markerWidth * CGFloat(time)
            
            let rect = CGRect(
                x: originX,
                y: centerY - (lineHeight / 2),
                width: markerWidth,
                height: lineHeight
            )
            
            context.fill(rect)
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let videoProgressSlider: VideoProgressSlider = {
        let slider: VideoProgressSlider = .init()
        let markerTimes: [TimeInterval] = [0, 1, 3, 5, 10, 15, 29, 30]
        slider.markerTimes = markerTimes
        return slider
    }()
    UIViewWrapper(view: videoProgressSlider)
        .frame(width: .infinity, height: 48)
        .padding(.horizontal, 8)
        .background{
            Color.red
        }
}
