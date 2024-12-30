import UIKit
import Combine

/// メールリストセルのビューモデル
final class MailListCellViewModel {
    
    /// メールモデル
    var mail: Mail
    /// 送信者
    var sender: String {
        mail.sender
    }
    /// 件名
    var subject: String {
        mail.subject
    }
    /// 本文
    var body: String {
        mail.body
    }
    /// 受信日時
    var timestamp: String {
        mail.timestamp.toString(format: .hhmm_colon)
    }
    /// 既読かどうか
    var isRead: Bool {
        mail.isRead
    }
    /// 編集状態かどうか
    var isEditing: Bool = false
    
    init(mail: Mail) {
        self.mail = mail
    }
}
