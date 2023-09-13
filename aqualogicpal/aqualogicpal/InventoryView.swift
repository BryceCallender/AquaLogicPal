import SwiftUI

struct InventoryView: View {
    @Environment(AquaLogicPalStore.self) private var store
    
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Inventory")) {
                    ForEach(store.inventory) { item in
                        NavigationLink(destination: InventoryDetail(item: item)) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                if item.amount != nil {
                                    Text(String(format: "%g containers", item.amount!))
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await loadInventory()
        }
        .toolbar {
            Button(action: {
                showSheet = true
            }, label: {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showSheet) {
            AddItemSheetView()
                .presentationDetents([.fraction(0.45), .medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    func loadInventory() async {
        await store.getInventory()
    }
}

#Preview {
    InventoryView()
        .environment(AquaLogicPalStore())
}
