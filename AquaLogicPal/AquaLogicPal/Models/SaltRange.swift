import Foundation

struct SaltRange: Comparable, Identifiable {
    let id: UUID = UUID()
    let eventTime: Date
    let minSalt: Double
    let maxSalt: Double
    
    static func ==(lhs: SaltRange, rhs: SaltRange) -> Bool {
        return lhs.maxSalt == rhs.maxSalt
    }

    static func <(lhs: SaltRange, rhs: SaltRange) -> Bool {
        return lhs.minSalt < rhs.minSalt
    }
}
