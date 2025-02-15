import UIKit
import SwiftUI
import RealmSwift

final class RealmViewController: UIViewController {
    /// 保存(同期)ボタン
    private lazy var saveSyncButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "保存(同期)",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .blue
        )
        button.addTarget(self, action: #selector(saveSync) , for: .touchUpInside)
        return button
    }()
    /// 保存(同期)ボタン
    private lazy var saveAsyncButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "保存(非同期)",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .blue
        )
        button.addTarget(self, action: #selector(saveAsync) , for: .touchUpInside)
        return button
    }()
    /// 削除ボタン
    private lazy var removeButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "削除",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .red
        )
        button.addTarget(self, action: #selector(remove) , for: .touchUpInside)
        return button
    }()
    /// 取得ボタン
    private lazy var fetchAllButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "取得",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .green
        )
        button.addTarget(self, action: #selector(fetchAll) , for: .touchUpInside)
        return button
    }()
    /// 取得ボタン(エラー)
    private lazy var fetchAllwithErrorButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "取得(エラー)",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .systemGreen
        )
        button.addTarget(self, action: #selector(fetchAllWithInccorrectThreadUsage) , for: .touchUpInside)
        return button
    }()
    /// 取得ボタン(スレッドセーフ)
    private lazy var fetchAllSatisfyButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "取得(スレッドセーフ)",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .cyan
        )
        button.addTarget(self, action: #selector(fetchAllSafely) , for: .touchUpInside)
        return button
    }()
    /// 内部保持データ
    var userList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func setup() {}
    
    func layout() {
        
        view.backgroundColor = .white
        
        let mainStackView: UIStackView = .init(
            arrangedSubviews: [
                saveSyncButton,
                saveAsyncButton,
                removeButton,
                fetchAllButton,
                fetchAllwithErrorButton,
                fetchAllSatisfyButton
            ],
            axis: .vertical,
            spacing: 16,
            directionalLayoutMargins: .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
        let horizontalStackView: UIStackView = .init(
            arrangedSubviews: [mainStackView],
            axis: .horizontal,
            alignment: .center
        )
        view.addSubview(horizontalStackView)
        horizontalStackView
            .anchor(
                top: view.topAnchor,
                left: view.leadingAnchor,
                bottom: view.bottomAnchor,
                right: view.trailingAnchor
            )
        saveSyncButton.anchor(height: 48)
        saveAsyncButton.anchor(height: 48)
        removeButton.anchor(height: 48)
        fetchAllButton.anchor(height: 48)
        fetchAllwithErrorButton.anchor(height: 48)
        fetchAllSatisfyButton.anchor(height: 48)
    }
    
    let realmManager: RealmManager = .init()
    
    /// 保存
    @objc func saveSync() {
        let user: User = .init()
        user.id = UUID().uuidString
        user.name = "ユーザー\(Int.random(in: 1..<100))"
        user.age = Int.random(in: 1..<100)
        userList.append(user)
        realmManager.saveSync(user)
        Logger.shared.logLevel(.debug, message: "保存処理")
    }
    /// 保存
    @objc func saveAsync() {
        let user: User = .init()
        user.id = UUID().uuidString
        user.name = "ユーザー\(Int.random(in: 1..<100))"
        user.age = Int.random(in: 1..<100)
        userList.append(user)
        Task {
            await realmManager.saveAsync(user)
            print("保存処理(非同期)")
        }
    }
    /// 削除
    @objc func remove() {
        if let lastUser: User = userList.last {
            realmManager.delete(lastUser)
            userList.removeLast()
        }
        Logger.shared.logLevel(.debug, message: "削除処理")
    }
    /// 全取得
    @objc func fetchAll() {
        userList = []
        if let users = realmManager.fetchAll(User.self) {
            users.forEach {
                userList.append($0)
            }
            print("取得データ:",users)
            print("保持データ件数:",userList.count)
        }
    }
    /// 全取得(incorrect thread: realm作成スレッドと実行スレッドが異なるためエラー発生)
    /// - note: バックグラウンドスレッドで取得したRealmオブジェクトをメインスレッドで使うような処理
    /// →Realm のオブジェクトは スレッド間で共有できないためクラッシュ
    @objc func fetchAllWithInccorrectThreadUsage() {
        DispatchQueue.global(qos: .background).async {
            if let users = self.realmManager.fetchAll(User.self) {
                DispatchQueue.main.async {
                    print("取得データ:", users) // ⚠️ ここでRealmのオブジェクトを異なるスレッドで使用
                    print("保持データ件数:", self.userList.count)
                }
            }
        }
    }
    /// Results<T> はそのまま別スレッドに渡せないので、Array<T> に変換
    /// さらに struct に変換して、スレッド間で安全に渡せるようにする
    @objc func fetchAllSafely() {
        DispatchQueue.global(qos: .background).async {
            if let users = self.realmManager.fetchAll(User.self) {
                
                // スレッドセーフなデータとして変換
                let safeUsers = Array(users).map { UserStruct(id: $0.id, name: $0.name, age: $0.age) }
                
                DispatchQueue.main.async {
                    print("取得データ:", safeUsers)
                    print("保持データ件数:", self.userList.count)
                }
            }
        }
    }
}

