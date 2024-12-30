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
        overlayView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTouch))]
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)
        // トランジションを実行
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.5
        }, completion:nil)
    }
    
    // overlayViewをタップした時に呼ばれる
    @objc func overlayViewDidTouch(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
