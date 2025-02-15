import RealmSwift
import UIKit

final class RealmManager {
    
//    private let realm: Realm
//    
//    /// 初期化
//    init() {
//        do {
//            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
//            self.realm = try Realm()
//        } catch {
//            fatalError("Realmの初期化に失敗: \(error)")
//        }
//    }
    /// データを追加・更新(主キーがある場合は更新される): 同期
    /// - note: 即時実行→writeの中の処理はブロックされ完了まで待つ、スレッドをブロック→メインスレッドで実行するとUIフリーズ可能性がある(小規模な書き込みに向いている)
    func saveSync<T: Object>(_ object: T) {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            Logger.shared.logLevel(.debug, message: "データの保存に失敗しました:\(error)")
        }
    }
    /// データを追加・更新(主キーがある場合は更新される): 非同期
    /// ◻️writeAsync で Cannot schedule async transaction. Make sure you are running from inside a run loop. エラーの原因と解決方法
    /// - note: writeAsyncはRunloopが必要、Runloopがないと動作エラーになる。→Cannot schedule async transaction. Make sure you are running from inside a run loop.
    /// DispatchQueue.global(qos: .background).async には RunLoop がない
    /// DispatchQueue.global() は デフォルトでは RunLoop を持たないバックグラウンドスレッド で実行される。そのため、ここで writeAsync を実行するとエラーが発生する
    /// メインスレッドで実行する(Dispatch.main.asyncではRunloopがある)
    /// Dispatch.main.asyncまたは@MainActorの付与
    /// - note: Runloopはスレッドがアイドル状態にならず、定期的にタスクを処理し続ける仕組み のこと
    func saveWithWriteAsync<T: Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            print("saveWithWriteAsyncのスレッド:\(Thread.current)")
            do {
                let realm = try Realm() // ✅ バックグラウンドスレッドで Realm インスタンスを作成
                
                realm.writeAsync {
                    print("🔄 `writeAsync` 内部の処理が実行されるスレッド: \(Thread.current)")
                    realm.add(object, update: .modified) // ✅ 非同期でデータを追加
                } onComplete: { error in
                    
                        if let error = error {
                            print("エラー発生: \(error)")
                            completion(.failure(error)) // ❌ エラー発生時に通知
                        } else {
                            print("✅ 保存完了！")
                            print("saveWithWriteAsync完了後のスレッド:\(Thread.current)")
                            completion(.success(())) // ✅ 成功時に通知
                        }
                }
            } catch {
                print("エラー発生: \(error)")
                completion(.failure(error)) // ❌ Realm のインスタンス作成失敗時に通知
            }
        }
    }
    
    /// データを追加・更新(主キーがある場合は更新される): 非同期(既存の同期処理を非同期的に扱うメソッドを使用)
    /// - note: 非同期処理→バックグラウンドで書き込み処理を実行し完了後に次の処理が実行される、メインスレッドをブロックしない(大量のデータ処理に向いている)
    /// ◻️withCheckedContinuation を使う理由
    /// ・writeAsync に onComplete があるなら withCheckedContinuation なしでも良いのでは？
    /// → 実は onComplete を await で待つには、withCheckedContinuation を使わないと async に適用できない。
    /// writeAsync(onComplete:) は 非同期で処理されるが、async メソッドではない
    /// await を使うためには、onComplete のコールバックを async/await に変換する必要がある。そのため withCheckedContinuation を使い、完了したら await から抜ける 仕組みを作る
    /// →withCheckedContinuationでawaitしないと呼び出し元で後続の処理が先に実行されてしまう：確認済み
    /// ◻️Mainactorを付与する理由
    /// @MainActorを付与しないと呼び出し元(Task)がメインスレッドでもバックグラウンドスレッドでインスタンス化される
    ///  writeAsyncは別の異なるバックグラウンドスレッドとなるためincorrect thread errorになる
    @MainActor
    func saveAsync<T: Object>(_ object: T) async {
        do {
            // メインスレッドで作成される
            let realm = try await Realm()
            await withCheckedContinuation { continuation in
                realm.writeAsync { // ✅ 書き込み処理
                    print("saveAsync")
                    print("書き込み処理のスレッドはメインスレッドかどうか:\(Thread.isMainThread)")
                    print("書き込み処理のスレッド:\(Thread.current)")
                    realm.add(object, update: .modified)
                } onComplete: { error in // ✅ 書き込み完了時のハンドラー
                    if let error = error {
                        print("エラー発生: \(error)")
                    }
                    print("saveAsync onComplete")
                    continuation.resume() // ✅ 完了を通知
                }
            }
        } catch {
            
        }
    }
    /// データを一括追加・更新
    func saveSync<T: Object>(_ objects: [T]) {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch {
            print("データの保存に失敗しました:\(error)")
        }
    }
    
    /// 全データ取得
    func fetchAll<T: Object>(_ objectType: T.Type) -> Results<T>? {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            return realm.objects(objectType)
        } catch {
            print("データの取得に失敗しました:\(error)")
        }
        return nil
    }
    
    /// フィルター付きデータ取得
    func fetch<T: Object>(_ objectType: T.Type, predicate: NSPredicate) -> Results<T>? {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            return realm.objects(objectType).filter(predicate)
        } catch {
            print("データの取得に失敗しました:\(error)")
        }
        return nil
    }
    
    /// IDでデータを取得
    func fetchById<T: Object>(_ objectType: T.Type, key: Any) -> T? {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            return realm.object(ofType: objectType, forPrimaryKey: key)
        } catch {
            print("データの取得に失敗しました:\(error)")
        }
        return nil
    }
    
    /// データを更新（ブロック内で直接変更）
    func update(_ block: () -> Void) {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            try realm.write {
                block()
            }
        } catch {
            print("データの更新に失敗しました:\(error)")
        }
    }
    
    /// データを削除
    func delete<T: Object>(_ object: T) {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("データの削除に失敗しました:\(error)")
        }
    }
    
    /// 全データ削除（特定のモデルクラス）
    func deleteAll<T: Object>(_ objectType: T.Type) {
        do {
            print("Realmインスタンスがメインスレッドで作成されたかどうか:\(Thread.isMainThread)")
            let realm = try Realm()
            let objects = realm.objects(objectType)
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print("全データの削除に失敗しました:\(error)")
        }
    }
    
    /// Realmの全データを削除（完全リセット）
    func deleteAllRealmData() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Realmの全データ削除に失敗しました:\(error)")
        }
    }
}
