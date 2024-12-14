import SwiftUI
/// UIViewをpreview表示させる際のラッパー
struct UIViewWrapper: UIViewRepresentable {
    let view: UIView
    var update: (() -> Void)? = nil
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        update?()
    }
}

/// UIViewControlerをPreview表示させるためのラッパー
struct UIViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    var update: (() -> Void)? = nil
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        update?()
    }
}
