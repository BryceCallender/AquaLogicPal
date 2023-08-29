import Foundation

struct SaltData: Codable, Identifiable {
    var eventTime: Date
    var salt: Double
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case eventTime = "EventTime"
        case salt = "Salt"
    }
}
