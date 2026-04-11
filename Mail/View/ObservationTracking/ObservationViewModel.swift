import Foundation

@MainActor @Observable
final class ObservationViewModel {
    var count: Int = .zero
    var countStr: String {
        count.description
    }
    var isSelected: Bool = false
    var isSelectedStr: String {
        isSelected ? "選択" : "未選択"
    }
    
    func countUp() {
        count += 1
    }
    
    func countDown() {
        if count == .zero { return }
        count -= 1
    }
    
    func changeSelectState() {
        isSelected.toggle()
    }
}
