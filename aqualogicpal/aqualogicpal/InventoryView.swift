import SwiftUI

struct InventoryView: View {
    @State private var loading = false
    @State private var inventory = [InventoryItem]()
    
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            if loading {
                ProgressView()
                    .tint(.dragoonBlue)
                    .scaleEffect(3.0)
            } else {
                List {
                    Section(header: Text("Inventory")) {
                        ForEach(inventory) { item in
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
        do {
            loading = true
            let inventoryQuery = supabase.database.from("Inventory").select()
            inventory = try await inventoryQuery.execute().value
            loading = false
        } catch {
            inventory = []
            loading = false
            print("### Loading Inventory Error: \(error)")
        }
    }
}

#Preview {
    InventoryView()
}
