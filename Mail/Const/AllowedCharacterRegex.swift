import Foundation
/// 入力時に許可する文字種
enum AllowedCharacterRegex: String {
    // 半角英数字
    case halfWidthAlphanumeric = "[0-9a-zA-Z]"
    // 半角数字
    case halfWidthNumbers = "[0-9]"
    // 半角英字
    case halfWidthAlphabet = "[a-zA-Z]"
    // 半角英数記号
    case halfWidthSymbols = "[ -~]"
    // 半角メールアドレス使用記号
    case emailSymbols = "[0-9a-zA-Z#\\$&'*+./=?@^_{}~-]"
    // 半角英数パスワード使用記号
    case passwordSymbols = "[0-9a-zA-Z!\"#\\$%&'@_-]"
    // 全角文字
    case fullWidthCharacters = "[^ -~｡-ﾟ\t]"
    // 全角カナ
    case fullWidthKatakana = "[ァ-タダ-ヶー]"
    // 全角文字、半角英数記号（混在）
    case mixedFullAndHalfWidth = "[^\t]"

    // 正規表現を取得
    var pattern: String {
        return self.rawValue
    }
}

