import Foundation
import RealmSwift
/// Realmで扱うモデル
final class User: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var age: Int
}
/// Realmオブジェクトをスレッドセーフに扱うためのデータモデル
struct UserStruct {
    let id: String
    let name: String
    let age: Int
}
