import UIKit
import Combine
/// メールリストのビューモデル
// - TODO: データ更新通知をクロージャではなくCombineでの更新に差し替える
@MainActor
final class MailListControllerViewModel {
    /// メールリストのセルビューモデルのリスト
    /// - note:実際にサーバーから受け取るデータと表示するデータの型が異なる場合、cellでもviewModelで変換し、本体のviewModelでcellViewModelのリストを持つようにする
    private(set) var cellViewModels: [MailListCellViewModel] = []
    private var isLoading: Bool = false
    /// リストの最大読み込み件数
    private let maxItems: Int = 50
    /// update closure
    var onDataUpdate: (() -> Void)?
    
    /// リストを取得する(初回)
    func firstLoad() {
        Task {
            // 初期データの取得
            // 最後のIDはnilで全件取得
            await fetchMailData(lastID: nil)
        }
    }
    /// リストを追加取得する
    func moreLoad() {
        // ローディング中でない、最大読み込み件数未満の場合通す
        guard !isLoading, cellViewModels.count < maxItems else { return }
        Task {
            // 現在の最後のIDを取得
            let lastID: String? = cellViewModels.last?.mail.id.uuidString
            await fetchMailData(lastID: lastID)
        }
    }
    /// リストの初期化
    func refresh() {
        cellViewModels = []
        firstLoad()
    }
    
    private func fetchMailData(lastID: String?) async {
        isLoading = true
        // 3秒停止(API通信を再現)
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        let mails = MailRepository.fetchMails()
        let newItems = mails.map {
            MailListCellViewModel(mail: $0)
        }
        cellViewModels.append(contentsOf: newItems)
        onDataUpdate?()
        isLoading = false
    }
}
