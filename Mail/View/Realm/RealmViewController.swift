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
    /// 保存(非同期)ボタン
    private lazy var saveWriteAsyncButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "保存(非同期)",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .blue
        )
        button.addTarget(self, action: #selector(saveWithWriteAsync) , for: .touchUpInside)
        return button
    }()
    /// リスト保存(非同期)ボタン
    private lazy var saveListAsyncWriteButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "リスト保存(非同期)",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .magenta
        )
        button.addTarget(self, action: #selector(saveListAsyncWrite) , for: .touchUpInside)
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
    // 保存+取得ボタン
    private lazy var saveAndFetchButton: CommonButtonWithConfig = {
        let button: CommonButtonWithConfig = .init(
            title: "保存+取得ボタン",
            titleColor: .white,
            font: .systemFont(ofSize: 18, weight: .bold),
            cornerRadius: 8,
            normalColor: .black
        )
        button.addTarget(self, action: #selector(saveAndFetch) , for: .touchUpInside)
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
                saveWriteAsyncButton,
                saveListAsyncWriteButton,
                removeButton,
                fetchAllButton,
                fetchAllwithErrorButton,
                fetchAllSatisfyButton,
                saveAndFetchButton
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
        saveWriteAsyncButton.anchor(height: 48)
        saveListAsyncWriteButton.anchor(height: 48)
        removeButton.anchor(height: 48)
        fetchAllButton.anchor(height: 48)
        fetchAllwithErrorButton.anchor(height: 48)
        fetchAllSatisfyButton.anchor(height: 48)
        saveAndFetchButton.anchor(height: 48)
    }
    
    let realmManager: RealmManager = .init()
    
    /// 保存(同期)
    @objc func saveSync() {
        let user: User = .init()
        user.id = UUID().uuidString
        user.name = "ユーザー\(Int.random(in: 1..<100))"
        user.age = Int.random(in: 1..<100)
        userList.append(user)
        realmManager.saveSync(user)
        Logger.shared.logLevel(.debug, message: "保存処理")
    }
    /// 保存(非同期)
    @objc func saveWithWriteAsync() {
        let user: User = .init()
        user.id = UUID().uuidString
        user.name = "ユーザー\(Int.random(in: 1..<100))"
        user.age = Int.random(in: 1..<100)
        userList.append(user)
        realmManager.saveWithWriteAsync(user) { result in
            switch result {
            case .success(_):
                if let users = self.realmManager.fetchAll(User.self) {
                    let safeUsers = Array(users).map { UserStruct(id: $0.id, name: $0.name, age: $0.age) }
                    print("saveWithWriteAsync(viewController)のスレッド:\(Thread.current)")
                    print("取得データ:", safeUsers)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    /// 保存(非同期)
    @objc func saveAsync() {
        let user: User = .init()
        user.id = UUID().uuidString
        user.name = "ユーザー\(Int.random(in: 1..<100))"
        user.age = Int.random(in: 1..<100)
        userList.append(user)
        Task {
            await realmManager.saveAsyncWithCheckedContinuation(user)
            print("保存処理(非同期)")
        }
    }
    /// リストの保存(非同期)
    @objc func saveListAsyncWrite() {
        Task {
        var users: [User] = []
        for _ in 0..<20 {
            let user: User = .init()
            user.id = UUID().uuidString
            user.name = "ユーザー\(Int.random(in: 1..<100))"
            user.age = Int.random(in: 1..<100)
            userList.append(user)
            users.append(user)
        }
            await realmManager.saveAsyncList(users)
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
        fetchAllinMainThread {}
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
    /// 保存+取得
    @objc func saveAndFetch() {
        fetchAllinMainThread {
            print("fetchAllinMainThread complete")
            self.save {
                print("save complete")
                self.fetchAllinMainThread {
                    print("fetchAllinMainThread complete")
                }
            }
        }
    }
    
    func save(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            print("データ保存処理(同期)の実行スレッド:\(Thread.current)")
            let user: User = .init()
            user.id = UUID().uuidString
            user.name = "ユーザー\(Int.random(in: 1..<100))"
            user.age = Int.random(in: 1..<100)
            self.userList.append(user)
            self.realmManager.saveSync(user)
            completion()
        }
    }
    
    func fetchAllinMainThread(completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            print("データ取得処理の実行スレッド:\(Thread.current)")
            self?.userList = []
            if let users = self?.realmManager.fetchAll(User.self) {
                users.forEach {
                    self?.userList.append($0)
                }
                print("取得データ:",users)
                print("保持データ件数:",self?.userList.count ?? 0)
                completion()
            }
        }
    }
}

