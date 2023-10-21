import Foundation

struct FilterRecord: Codable, Identifiable {
    var id: Int?
    var cleanedOn: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case cleanedOn = "CleanedOn"
    }
}
