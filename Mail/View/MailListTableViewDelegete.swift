import UIKit

/// メールリストのテーブルビューデリゲート定義
protocol MailListTableViewDelegate: AnyObject {
    /// ひっぱり更新
    func pullToReflesh()
    /// セルタップ時
    func didSelectCell(_ model: MailListCellViewModel)
}
