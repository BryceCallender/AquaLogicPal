import SwiftUI

struct InventoryItemView: View {
    var inventoryItem: InventoryItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(inventoryItem.name)
                .font(.title)
            
            Text("\(String(inventoryItem.amount!)) containers")
                .font(.subheadline)
            
            switch inventoryItem.itemType {
            case .liquid:
                LiquidView(amount: inventoryItem.amount!)
            default:
                Text("")
            }
            
            Button(action: markForReplacement) {
                Text("Needs Replacement")
            }
        }
    }
    
    func markForReplacement() {
        
    }
}

#Preview {
    InventoryItemView(inventoryItem: InventoryItem(id: 1, name: "Muriatic Acid", amount: 2.25, needsReplacement: false, itemType: .liquid))
}
