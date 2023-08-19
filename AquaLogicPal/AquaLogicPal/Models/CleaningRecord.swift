import Foundation

struct CleaningRecord: Codable, Identifiable {
    let id: Int
    let timestamp: Date
    let addedChemicals: Bool
    let skimmed: Bool
    let brushed: Bool
    let skimmerPot: Bool
    let brushedTiles: Bool
    let chemicalImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case timestamp = "CleanedOn"
        case addedChemicals = "AddedChemicals"
        case skimmed = "Skimmed"
        case brushed = "Brushed"
        case skimmerPot = "SkimmerPot"
        case brushedTiles = "BrushedTiles"
        case chemicalImageUrl = "ChemicalImageUrl"
    }
}
