import UIKit
/// 入力バリデーションチェック可能
protocol InputValidatable {
    /// 入力許可文字種
    var allowedRegex: AllowedCharacterRegex { get set }
    /// 入力最大文字数
    var maxCharacterCount: Int? { get set }
    /// エラーメッセージ
    var errorMessage: String { get set }
    /// 入力終了時のバリデーション
    func validate(text: String?) -> Bool
    /// 入力テキストをフィルタリングして許可された文字列のみを返す
    func filteredText(from text: String) -> String
}

extension InputValidatable {
    
    var allowedRegex: AllowedCharacterRegex {
        /// 全角文字、半角英数記号（混在）
        .mixedFullAndHalfWidth
    }
    
    func validate(text: String?) -> Bool {
        return true
    }
    
    func filteredText(from text: String) -> String {
        let regex = allowedRegex.pattern
        return text.filter { character in
            /// 指定された文字列 (character) が正規表現 (regex) に一致するかを判定する処理
            /// SELF: 評価対象の文字列（evaluate(with:)に渡す文字列）
            /// MATCHES: 正規表現を使って一致するかを判定するキーワード
            /// %@: フォーマット文字列(regexがここに挿入される)
            NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: String(character))
        }
    }
}
