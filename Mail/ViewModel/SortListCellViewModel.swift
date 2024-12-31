import UIKit
/// ソートリストセルのビューモデル
final class SortListCellViewModel {
    
    /// ソート種別
    var sortKind: SortKind
    /// チェック状態かどうか
    var isChecked: Bool = false
    
    init(sortKind: SortKind) {
        self.sortKind = sortKind
    }
}
