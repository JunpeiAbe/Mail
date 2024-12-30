import UIKit

final class PresentationController: UIPresentationController {
    // 呼び出し元のView Controller の上に重ねるオーバレイ
    var overlayView: UIView = {
        let view: UIView = .init()
        return view
    }()
    
    // 表示トランジション開始前に呼ばれる
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        overlayView.frame = containerView.bounds
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)
        // トランジションを実行
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.5
        }, completion:nil)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                self?.overlayView.alpha = 0
            }
        )
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.overlayView.removeFromSuperview()
        }
    }
}
