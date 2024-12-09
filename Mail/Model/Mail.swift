import Foundation

/// メールのデータモデル
struct Mail: Identifiable {
    /// メールのID
    var id: UUID
    /// メール送信者
    var sender: String
    /// メールの受信者
    var recipient: String
    /// メールの件名
    var subject: String
    /// メールの本文
    var body: String
    /// 既読かどうか
    var isRead: Bool
    /// 送受信日時
    var timestamp: Date
}
