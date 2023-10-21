import SwiftUI

struct InventoryView: View {
    @Environment(AquaLogicPalStore.self) private var store
    
    @State private var showSheet = false
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(2.0)
                    .tint(.dragoonBlue)
            } else {
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
        isLoading = true
        await store.getInventory()
        isLoading = false
    }
}

#Preview {
    InventoryView()
        .environment(AquaLogicPalStore())
}
