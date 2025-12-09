import UIKit
import SwiftUI

final class VideoProgresSliderViewController: UIViewController {
    private let videoProgressSlider: VideoProgressSlider = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup(){
        videoProgressSlider.markerTimes = [0,10,15,20]
    }
    
    func layout() {
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [videoProgressSlider],
            axis: .horizontal,
            directionalLayoutMargins: .init(top: 0, leading: 8, bottom: 0, trailing: 8),
            alignment: .bottom
        )
        
        view.addSubview(mainStackView)
        
        mainStackView.anchor(
            top: self.view.topAnchor,
            left: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            right: self.view.trailingAnchor
        )
    }
}

#Preview {
    let viewController: VideoProgresSliderViewController = {
        let vc: VideoProgresSliderViewController = .init()
        return vc
    }()
    UIViewControllerWrapper(viewController: viewController)
}

