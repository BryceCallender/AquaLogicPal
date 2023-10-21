import Foundation
import SwiftUI

struct CleaningRecord: Codable, Identifiable {
    var id: Int?
    var timestamp: Date?
    var addedAcid: Bool = false
    var addedChlorine: Bool = false
    var skimmed: Bool = false
    var brushed: Bool = false
    var skimmerPot: Bool = false
    var brushedTiles: Bool = false
    var chemicalImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case timestamp = "CleanedOn"
        case addedAcid = "AddedAcid"
        case addedChlorine = "AddedChlorine"
        case skimmed = "Skimmed"
        case brushed = "Brushed"
        case skimmerPot = "SkimmerPot"
        case brushedTiles = "BrushedTiles"
        case chemicalImageUrl = "ChemicalImageUrl"
    }
}
