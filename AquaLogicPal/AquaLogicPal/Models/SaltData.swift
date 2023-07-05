import Foundation

struct SaltData: Codable, Identifiable {
    var eventTime: Date
    var salt: Double
    var id: Int
}
