import UIKit
import SwiftUI

class VideoProgressSlider: UISlider {
    /// スライダー(ライン)の高さ
    var lineHeight: CGFloat = 4.0
    /// 間隔
    var sideOffset: CGFloat = 0.0
    /// マーク背景色
    var markColor: UIColor = .lightYellow
    /// マーカー用レイヤー群
    private var markerLayers: [CALayer] = []
    /// 動画の総時間（秒）
    var duration: TimeInterval = 30
    /// マークしたい秒数（例: [5, 10]）
    var markerTimes: [TimeInterval] = []

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // スライダー全体から上下10ptずつ余白を取った描画領域
        let innerRect = rect.insetBy(dx: 0.0, dy: 10.0)
        // 右側（未再生側）のトラック画像
        if let maximumImage = makeTrackImage(size: innerRect.size, lineColor: .lightGray) {
            setMaximumTrackImage(maximumImage.resizableImage(withCapInsets: .zero),
                                 for: .normal)
        }
        // 左側（再生済み側）のトラック画像
        if let minimumImage = makeTrackImage(size: innerRect.size,
                                             lineColor: .deepBlue) {
            setMinimumTrackImage(minimumImage.resizableImage(withCapInsets: .zero),
                                 for: .normal)
        }
        // つまみの画像
        let thumbImage: UIImage = .init(systemName: "circle.fill")!
        setThumbImage(thumbImage, for: .highlighted)
        setThumbImage(thumbImage, for: .normal)
    }

    /// レイアウトが変わるたびにマーカー位置を更新（縦横回転にも対応）
    override func layoutSubviews() {
        super.layoutSubviews()
        makeMarkers()
    }

    /// 1本のトラック線だけを描画した UIImage を生成する
    private func makeTrackImage(size: CGSize, lineColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        let innerRect = CGRect(origin: .zero, size: size)
        // トラックの線を描画
        context.setLineWidth(lineHeight)
        context.setLineCap(.round)
        // 左端 → 右端に線を引く
        context.move(to: CGPoint(x: sideOffset,
                                 y: innerRect.height / 2))
        context.addLine(to: CGPoint(x: innerRect.size.width - sideOffset,
                                    y: innerRect.height / 2))
        context.setStrokeColor(lineColor.cgColor)
        context.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// イベントポイントのマーカー設定
    private func makeMarkers() {
        // 既存マーカーを全て削除
        markerLayers.forEach { $0.removeFromSuperlayer() }
        markerLayers.removeAll()
        guard duration > 0 else { return }
        guard !markerTimes.isEmpty else { return }
        // UISliderが実際に使っているトラック領域を取得
        let trackRect = self.trackRect(forBounds: bounds)
        // sideOffset を考慮した実際の描画可能幅
        let availableWidth = trackRect.width - sideOffset * 2
        let trackMinX = trackRect.minX + sideOffset
        let markerWidth = availableWidth / duration
        for time in markerTimes {
            // 範囲外は無視
            guard time >= 0, time <= duration else { continue }
            // 0.0〜1.0 の割合に変換
            let ratio = CGFloat(time / duration)
            // マーカー中心のX座標 = トラック左端 + 有効幅 × 割合
            let centerX = trackMinX + availableWidth * ratio
            // マーカー用のレイヤーを作成
            let layer = CALayer()
            layer.backgroundColor = markColor.cgColor
            layer.frame = CGRect(x: centerX - markerWidth / 2,
                                 y: trackRect.midY - lineHeight / 2,
                                 width: markerWidth,
                                 height: lineHeight)
            self.layer.addSublayer(layer)
            markerLayers.append(layer)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let videoProgressSlider: VideoProgressSlider = {
        let slider: VideoProgressSlider = .init()
        let markerTimes: [TimeInterval] = [0, 3, 5, 10, 15, 29]
        slider.markerTimes = markerTimes
        return slider
    }()
    UIViewWrapper(view: videoProgressSlider)
        .frame(width: .infinity, height: 48)
        .padding(16)
}
