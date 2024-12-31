import Foundation
/// ソート種別
enum SortKind: String, CaseIterable {
    /// 日付順 (最新のメールが最初)
    case dateDescending = "日付順(最新メール)"
    /// 日付順 (最古のメールが最初)
    case dateAscending = "日付順(最古メール)"
    /// 差出人順 (アルファベット昇順)
    case senderAscending = "差出人順(アルファベット昇順)"
    /// 差出人順 (アルファベット降順)
    case senderDescending = "差出人順(アルファベット降順)"
    /// 件名順 (アルファベット昇順)
    case subjectAscending = "件名順(アルファベット昇順)"
    /// 件名順 (アルファベット降順)
    case subjectDescending = "件名順(アルファベット降順)"
    /// 未読メールを優先
    case unreadFirst = "未読メールを優先"
}
