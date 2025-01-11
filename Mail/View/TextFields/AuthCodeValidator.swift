import UIKit
/// 認証コードのバリデーションクラス
final class AuthCodeValidator: InputValidatable {
    var maxCharacterCount: Int? = 4
    
    var errorMessage: String = .init()
    /// 半角数字のみ入力可
    var allowedRegex: AllowedCharacterRegex = .halfWidthNumbers
    /// 入力チェック
    func validate(text: String?) -> Bool {
        /// 入力値が空でないかどうか
        guard let text = text, !text.isEmpty else {
            errorMessage = ""
            return false
        }
        /// 入力値が4文字かどうか
        guard text.count == 4 else {
            errorMessage = "4文字以内で入力してください"
            return false
        }
        return true
    }
}
