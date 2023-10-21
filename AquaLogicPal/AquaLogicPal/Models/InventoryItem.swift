struct InventoryItem: Codable, Identifiable {
    let id: Int?
    let name: String
    var amount: Double?
    var needsReplacement: Bool
    let itemType: ItemType
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case amount = "Amount"
        case needsReplacement = "NeedsReplacement"
        case itemType = "ItemType"
    }
}
