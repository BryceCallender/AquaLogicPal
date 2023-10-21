import Foundation

struct SpaData: Identifiable, Comparable {
    var id = UUID()
    var count: Int
    var eventTime: Date
    
    static func ==(lhs: SpaData, rhs: SpaData) -> Bool {
        return lhs.count == rhs.count
    }

    static func <(lhs: SpaData, rhs: SpaData) -> Bool {
        return lhs.count < rhs.count
    }
}
