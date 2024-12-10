import Foundation

extension Date {
    func toString(format: DateFormat) -> String {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo") // 日本時間を指定
        return formatter.string(from: self)
    }
}

enum DateFormat: String {
    case yyyyMMddHHmmss_slash_colon = "yyyy/MM/dd HH:mm:ss"
    case hhmm_colon = "HH:mm"
}
