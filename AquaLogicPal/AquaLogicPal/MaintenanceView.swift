import SwiftUI

struct MaintenanceView: View {
    @StateObject var client = SupaClient.shared
    
    @State private var inventory = [InventoryItem]()
    @State private var cleaningRecords = [CleaningRecord]()
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Inventory")) {
                    ForEach(inventory) { item in
                        NavigationLink(item.name) {
                            InventoryItemView(inventoryItem: item)
                        }
                    }
                }
                
                Section(header: Text("Cleaning Records")) {
                    ForEach(cleaningRecords) { record in
                        NavigationLink(destination: CleaningDetailView(cleaningDetail: record)) {
                            CleaningRow(cleaningDetail: record)
                        }
                    }
                }
            }
        }
        .task {
            async let inventoryTask: Void = loadInventory()
            async let cleaningTask: Void = loadCleaningRecords()
            await [inventoryTask, cleaningTask]
        }
    }
    
    func loadInventory() async {
        do {
            let inventoryQuery = client.database.from("Inventory").select()
            inventory = try await inventoryQuery.execute().value
        } catch {
            inventory = []
            print("### Loading Inventory Error: \(error)")
        }
    }
    
    func loadCleaningRecords() async {
        do {
            let cleaningQuery = client.database.from("Cleaning").select()
            cleaningRecords = try await cleaningQuery.execute().value
        } catch {
            cleaningRecords = []
            print("### Loading Cleaning Records Error: \(error)")
        }
    }
}

#Preview {
    MaintenanceView()
}
