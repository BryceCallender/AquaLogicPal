import Foundation

struct SaltData: Codable, Identifiable, Comparable {
    var eventTime: Date
    var salt: Double
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case eventTime = "EventTime"
        case salt = "Salt"
    }
    
    static func ==(lhs: SaltData, rhs: SaltData) -> Bool {
        return lhs.salt == rhs.salt
    }

    static func <(lhs: SaltData, rhs: SaltData) -> Bool {
        return lhs.salt < rhs.salt
    }
}
