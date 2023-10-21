import Foundation

struct SpaEvent: Codable, Identifiable {
    var id: Int
    var startTime: Date
    var endTime: Date
    var maxTemp: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case maxTemp = "MaxTemp"
    }
}
