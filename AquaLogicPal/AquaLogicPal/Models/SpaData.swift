import Foundation

struct SpaData: Codable, Identifiable {
    var eventTime: Date
    var count: Int
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case eventTime = "EventTime"
        case count = "Count"
    }
}
