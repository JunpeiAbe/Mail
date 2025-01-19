import UIKit
import SwiftUI
import AVKit
import AVFoundation

final class VideoPlayerView: UIView {
    
    /// 動画プレイヤー
    private let player: AVPlayer = .init()
    private lazy var playerLayer: AVPlayerLayer = {
        let layer: AVPlayerLayer = .init(player: player)
        layer.videoGravity = .resizeAspect
        return layer
    }()
    
    /// 進行状況を示すスライダー
    private lazy var progressSlider: UISlider = {
        let slider: UISlider = .init()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        // 以下でデフォルトのつまみを消すことができる
        slider.setThumbImage(UIImage(), for: .normal)
        // スライダーを移動する時のみつまみを表示させるにはfor: .highlightedで画像をセットする
        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .highlighted)
        return slider
    }()
    
    /// 動画再生ボタン
    private lazy var playButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            titleColor: .systemGray4,
            shadowColor: .clear,
            normalColor: UIColor.clear,
            image: UIImage(systemName: "play.fill")
        )
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return button
    }()
    /// 一時停止ボタン
    private lazy var pauseButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            titleColor: .systemGray4,
            shadowColor: .clear,
            normalColor: UIColor.clear,
            image: UIImage(systemName: "pause.fill")
        )
        button.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        return button
    }()
    /// 最初から再生ボタン
    private lazy var restartButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            titleColor: .systemGray4,
            shadowColor: .clear,
            normalColor: UIColor.clear,
            image: UIImage(systemName: "arrow.trianglehead.clockwise")
        )
        button.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        return button
    }()
    
    /// 音声オンオフボタン
    private lazy var soundButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            titleColor: .systemGray4,
            shadowColor: .clear,
            normalColor: UIColor.clear,
            image: .init(systemName: "headphones")
        )
        button.addTarget(self, action: #selector(toggleSound), for: .touchUpInside)
        return button
    }()
    /// スクリーンサイズの変更ボタン
    private lazy var changeScreenSizeButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            titleColor: .systemGray4,
            shadowColor: .clear,
            normalColor: UIColor.clear,
            image: UIImage(systemName: "arrow.down.backward.and.arrow.up.forward.square")
        )
        // arrow.up.right.and.arrow.down.left.square
        button.addTarget(self, action: #selector(changeScreenSize), for: .touchUpInside)
        return button
    }()
    
    private var timeObserverToken: Any?
    
    // スクリーンサイズ切り替え用クロージャ
    var onChangeScreenSize: (() -> Void)?
    var screenSize: ScreenSize = .normal
    
    enum ScreenSize {
        case normal
        case full
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // タイムオブザーバーを削除
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func setup() {
        toggleButtons(isPlaying: false)
        restartButton.isHidden = true
        addTimeObserver()
        addBoundaryObserver()
    }
    
    func layout() {
        playerLayer.frame = bounds
        // 動画プレイヤーの設定
        layer.addSublayer(playerLayer)
        layer.backgroundColor = UIColor.black.cgColor
        
        self.addSubview(playButton)
        self.addSubview(pauseButton)
        self.addSubview(restartButton)
        self.addSubview(soundButton)
        self.addSubview(changeScreenSizeButton)
        self.addSubview(progressSlider)
        
        playButton.centerInSuperview()
        pauseButton.centerInSuperview()
        restartButton.centerInSuperview()
        changeScreenSizeButton
            .anchor(
                bottom: self.bottomAnchor,
                right: self.trailingAnchor,
                width: 30,
                height: 30
            )
        soundButton
            .anchor(
                bottom: self.bottomAnchor,
                right: changeScreenSizeButton.leadingAnchor,
                width: 30,
                height: 30
            )
        progressSlider.anchor(
            left: self.leadingAnchor,
            bottom: self.bottomAnchor,
            right: self.soundButton.leadingAnchor,
            height: 30
        )
    }
    /// 再生ボタンのアクション
    @objc private func playTapped() {
        player.play()
        toggleButtons(isPlaying: true)
    }
    /// 一時停止ボタンのアクション
    @objc private func pauseTapped() {
        player.pause()
        toggleButtons(isPlaying: false)
    }
    /// 最初から再生ボタンのアクション
    @objc private func restartTapped() {
        player.seek(to: .zero)
        toggleButtons(isPlaying: true)
        restartButton.isHidden = true
        player.play()
    }
    /// 音声オン・オフの切り替え
    @objc private func toggleSound() {
        player.isMuted.toggle()
        let newImage = player.isMuted
        ? UIImage(systemName: "headphones.slash")
        : UIImage(systemName: "headphones")
        soundButton.updateImage(image: newImage)
    }
    
    /// 拡大縮小の切り替え
    @objc private func changeScreenSize() {
        if screenSize == .normal {
            screenSize = .full
        } else {
            screenSize = .normal
        }
        
        let newImage = screenSize == .normal
        ? UIImage(systemName: "arrow.down.backward.and.arrow.up.forward.square")
        : UIImage(systemName: "arrow.up.right.and.arrow.down.left.square")
        changeScreenSizeButton.updateImage(image: newImage)
        // 拡大縮小は外部のUIViewControllerで実装することが一般的
        onChangeScreenSize?()
    }
    
    /// スライダーの値変更時にシークする
    @objc private func sliderValueChanged() {
        // 動画の総時間: player.currentItem?.duration
        guard let duration = player.currentItem?.duration.seconds,
              duration > 0 else {
            return
        }
        let newTime = Double(progressSlider.value) * duration
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    /// タイムオブザーバーを追加
    /// - note: 再生動画の進行状況をリアルタイムに監視し、プログレスに反映する
    /// AVPlayerには「再生中の現在時刻をポーリングする」仕組みが組み込まれていないためaddPeriodicTimeObserver(forInterval:queue:using:) を使って指定間隔で再生時間をコールバックとして取得する
    /// Timerは避けるべき：パフォーマンスや正確性の低下を招く可能性があるから
    private func addTimeObserver() {
        // 定期的に再生時間を監視する
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            guard let self = self,
                  let duration = self.player.currentItem?.duration.seconds,
                  duration > 0 else {
                return
            }
            let currentTime = time.seconds
            let progress = Float(currentTime / duration)
            self.progressSlider.value = progress
        })
    }
    /// 再生終了を監視する
    private func addBoundaryObserver() {
        if let duration = player.currentItem?.duration {
            player.addBoundaryTimeObserver(forTimes: [NSValue(time: duration)], queue: .main) { [weak self] in
                guard let self = self else { return }
                self.restartButton.isHidden = false
                self.toggleButtons(isPlaying: false)
            }
        }
    }
    
    private func toggleButtons(isPlaying: Bool) {
        playButton.isHidden = isPlaying
        pauseButton.isHidden = !isPlaying
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let videoPlayerView: VideoPlayerView = {
        let videoPlayerView: VideoPlayerView = .init()
        return videoPlayerView
    }()
    UIViewWrapper(view: videoPlayerView)
        .frame(width: .infinity, height: 200)
}
