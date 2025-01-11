import UIKit
import SwiftUI
/// 汎用入力欄クラス
/// - note: 入力値については①フォーカスアウト時②入力時(コピペ含む)でチェックを行う
final class CommonTextField: UITextField {
    
    /// 内部の余白
    private var textPadding: UIEdgeInsets = .zero
    /// バリデーション結果を返すクロージャー
    var onValidationFailure: (() -> Void)? // 失敗時のコールバック
    var onValidationSuccess: (() -> Void)? // 成功時のコールバック
    /// エラーメッセージ
    var errorMessage: String = .init()
    var normalBorderColor: UIColor = .systemGray5
    var highlightBorderColor: UIColor = .systemGray5
    var errorBorderColor: UIColor = .systemGray5
    // 入力チェック用のデリゲート
    var validator: InputValidatable?
    
    // 初期化
    init(
        placeholder: String? = nil,
        font: UIFont = UIFont.systemFont(ofSize: 16),
        textColor: UIColor = .black,
        normalBorderColor: UIColor = .systemGray5,
        highlightBorderColor: UIColor = .systemGray5,
        errorBorderColor: UIColor = .systemGray5,
        borderWidth: CGFloat = 1.5,
        cornerRadius: CGFloat = 8.0,
        textPadding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16),
        clearButtonMode: UITextField.ViewMode = .never,
        validator: InputValidatable
    ) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.font = font
        self.textColor = textColor
        self.layer.borderColor = normalBorderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.textPadding = textPadding
        self.clearButtonMode = clearButtonMode
        self.validator = validator
        self.normalBorderColor = normalBorderColor
        self.highlightBorderColor = highlightBorderColor
        self.errorBorderColor = errorBorderColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ボーダーカラーの更新
    func updateBorder() {
        if !(self.errorMessage.isEmpty) {
            // エラーメッセージがある場合
            self.layer.borderWidth = 2.0
            self.layer.borderColor = errorBorderColor.cgColor
        }
        else if self.isEditing {
            // フォーカスが当たっている場合
            self.layer.borderWidth = 2.0
            self.layer.borderColor = highlightBorderColor.cgColor
        }
        else {
            // 通常
            self.layer.borderColor = normalBorderColor.cgColor
        }
    }
    // プレースホルダーやテキストの表示領域を調整
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    // 編集時のテキスト領域を調整
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    // プレースホルダーの領域を調整
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

// - MARK: UITextFieldDelegate
extension CommonTextField: UITextFieldDelegate {
    // フォーカスが開始された時(入力開始時)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? CommonTextField
        else {
            return
        }
        textField.updateBorder()
    }
    // 文字を入力または削除したとき(入力中)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? CommonTextField, let validator = validator else { return true }
        // 現在のテキスト
        let currentText = textField.text ?? ""
        // 入力後のテキスト
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // 許可された文字列のみを抽出
        let filteredText = validator.filteredText(from: updatedText)
        
        // フィルタリング後の文字列が現在のテキストと異なる場合、更新
        if filteredText != updatedText {
            textField.text = filteredText
            return false // テキストを直接更新したため、return false
        }
        return true
    }
    // リターンキーを押したとき
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textField = textField as? CommonTextField
        else {
            return true
        }
        textField.endEditing(false)
        return true
    }
    // フォーカスを外したとき(入力終了時)
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? CommonTextField else { return }
        let isValid = textField.validator?.validate(text: textField.text) ?? true
        if isValid {
            /// エラーメッセージを初期化
            errorMessage = .init()
            onValidationSuccess?()
        } else {
            /// バリデーターのエラーメッセージを反映
            errorMessage = textField.validator?.errorMessage ?? ""
            onValidationFailure?()
        }
        textField.updateBorder()
    }
}

#Preview("CommonTextField", traits: .sizeThatFitsLayout) {
    let field: CommonTextField = {
        class Validotor: InputValidatable {
            var errorMessage: String = ""
            var allowedRegex: AllowedCharacterRegex = .halfWidthAlphanumeric
        }
        let field = CommonTextField(
            placeholder: "入力値",
            highlightBorderColor: .systemGreen,
            errorBorderColor: .systemRed,
            validator: Validotor()
        )
        return field
    }()
    
    UIViewWrapper(view: field)
        .frame(height: 44)
        .padding()
}
