import UIKit
import SwiftUI

final class VideoPlayerController: UIViewController {
    private let videoPlayerView: VideoPlayerView = .init()
    private var originalVideoSuperView: UIView?
    private var originalVideoPlayerViewHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup(){
        videoPlayerView.onChangeScreenSize = { [weak self] in
            print("change screen size")
            self?.rotate(orientation: .landscapeRight)
        }
    }
    
    func layout() {
        let videoStackView: UIStackView = .init(
            arrangedSubviews: [videoPlayerView],
            axis: .vertical
        )
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [videoStackView],
            axis: .horizontal,
            alignment: .top
        )
        
        view.addSubview(mainStackView)
        
        mainStackView.anchor(
            top: self.view.topAnchor,
            left: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            right: self.view.trailingAnchor
        )
        originalVideoSuperView = videoStackView
        originalVideoPlayerViewHeight = 250
        videoPlayerView.anchor(height: 250)
    }
    
    /// 強制的に画面回転を要求する
    private func rotate(orientation: UIInterfaceOrientation) {
        if #available(iOS 16.0, *) {
            guard let windowScene = view.window?.windowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation == .portrait ? .portrait : .landscapeRight)) { error in
                print(error)
                // 画面回転の要求が拒否された場合の処理
                print(orientation)
            }
            setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    override var shouldAutorotate: Bool {
        return true
    }
}

#Preview {
    let viewController: VideoPlayerController = {
        let vc: VideoPlayerController = .init()
        return vc
    }()
    UIViewControllerWrapper(viewController: viewController)
}
