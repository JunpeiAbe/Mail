import UIKit
import SwiftUI
import RxSwift
/// ユーザー検索画面
final class SearchUserViewController: UIViewController {
    
}

// MARK: UITableViewDelegate
extension SearchUserViewController: UITableViewDelegate {
    
}
// MARK: UITableViewDataSource
extension SearchUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
