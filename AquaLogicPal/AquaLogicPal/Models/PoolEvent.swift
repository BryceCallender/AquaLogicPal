import Foundation

struct PoolEvent: Codable, Identifiable {
    var id: Int?
    var eventTime: Date
    var type: PoolEventType
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case eventTime = "EventTime"
        case type = "PoolEventType"
    }
}
