import Foundation

struct PoolEvents: Codable, Comparable {
    var name: String
    var total: Int
    
    static func ==(lhs: PoolEvents, rhs: PoolEvents) -> Bool {
        return lhs.total == rhs.total
    }

    static func <(lhs: PoolEvents, rhs: PoolEvents) -> Bool {
        return lhs.total < rhs.total
    }
}
